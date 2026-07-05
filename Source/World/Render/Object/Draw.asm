
                ifndef _WORLD_RENDER_OBJECT_DRAW_
                define _WORLD_RENDER_OBJECT_DRAW_
; -----------------------------------------
; отображение объектов "мира"
; In:
;   A  - количество объектов в массиве SortBuffer
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; инициализация
                LD DE, Adr.SortBuffer
                LD B, A

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E

                ; SortBuffer хранит адрес FObject.Position.Y
                LD A, IYL
                SUB FObject.Position.Y
                LD IYL, A
                JR NC, $+4
                DEC IYH

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR Z, .ForcedVisibility                                         ; переход, если флаг не установлен,
                                                                                ; но необходимо проверить обновление screen block'а или принудительное обновление
                RES OBJECT_DIRTY_BIT, (IY + FObject.Flags)                      ; сброс флага

.NeedRefresh    PUSH DE
                ; расчёт положения объекта относительно верхнего-левого видимойго края
                CALL Utilities.TransformToScr                     
                LD (Kernel.Sprite.DrawClipping.PositionX), DE
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; определение способа отображения объекта
                LD A, (IY + FObjectDefaultSettings.Class)
                AND OBJECT_CLASS_MASK

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                PUSH IY
                LD HL, .JumpTable
                LD IX, Draw.SpriteClipping
                CALL Func.JumpTable

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                ; копирование bound спрайта
                POP HL
                LD DE, FObject.Bound
                ADD HL, DE
                LD DE, GameState.SpriteBound
                EX DE, HL
                LDI
                LDI
                LDI
                LDI

                ; первый проход гексагонов уже завершён и израсходовал колонковые
                ; флаги. Повторно отметить новый bound объекта, чтобы последующий
                ; проход тумана закрыл часть спрайта, попавшую в невидимую область.
                LD DE, (GameState.SpriteBound + FSpriteBound.Location)
                LD BC, (GameState.SpriteBound + FSpriteBound.Size)
                PUSH BC
                SET_PAGE_MAP
                POP BC
                CALL BufferUtilities.SpriteBound

                POP DE
.NextObject     POP BC
                DJNZ .Loop
.RET            RET

.ForcedVisibility; проверка принудительной видимости
                CHECK_VIEW_FLAG FORCED_FRAME_UPDATE_BIT
                JR NZ, .NeedRefresh                                             ; переход, если требуется принудительное обновление

                ; гексагон может обновить область за пределами bound объекта,
                ; например, половину расположенного ниже гексагона
                PUSH DE
                CALL .IntersectsScreenBlock
                POP DE
                JR C, .NeedRefresh                                              ; обновляемый screen block пересекает bound объекта
                JR .NextObject                                                  ; переход, если screen block не обновляется

; -----------------------------------------
; проверить пересечение bound объекта с обновляемыми screen block'ами
; In:
;   IY - адрес FObject, включена страница работы с объектами
; Out:
;   Carry установлен, если хотя бы один пересекаемый screen block обновляется
;   восстановлена страница работы с объектами
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   игровая область разбита на блоки 6x6 знакомест;
;   Adr.ScreenBlock хранит их по столбцам: column * 4 + row
; -----------------------------------------
.IntersectsScreenBlock
                LD A, (IY + FObject.Bound + FSpriteBound.Size.Width)
                OR A
                JR Z, .ScreenBlockNotFound
                LD C, A
                LD A, (IY + FObject.Bound + FSpriteBound.Location.X)
                LD E, A
                CALL .ScreenBlockIndex
                LD (.FirstColumn), A
                LD A, C
                DEC A
                ADD A, E
                CALL .ScreenBlockIndex
                LD (.LastColumn), A

                LD A, (IY + FObject.Bound + FSpriteBound.Size.Height)
                OR A
                JR Z, .ScreenBlockNotFound
                LD C, A
                LD A, (IY + FObject.Bound + FSpriteBound.Location.Y)
                LD E, A
                CALL .ScreenBlockIndex
                LD (.FirstRow), A
                LD A, C
                DEC A
                ADD A, E
                CALL .ScreenBlockIndex
                LD (.LastRow), A

                SET_PAGE_SCREEN_SHADOW
.FirstColumn    EQU $+1
                LD C, #00

.ScreenBlockColumn
.LastRow        EQU $+1
                LD A, #00
.FirstRow       EQU $+1
                SUB #00
                INC A
                LD B, A

                LD A, C
                ADD A, A
                ADD A, A
                LD E, A
                LD A, (.FirstRow)
                ADD A, E
                ADD A, LOW Adr.ScreenBlock
                LD L, A
                LD H, HIGH Adr.ScreenBlock

.ScreenBlockRow
                LD A, (HL)
                OR A
                JR NZ, .ScreenBlockFound
                INC L
                DJNZ .ScreenBlockRow

                INC C
.LastColumn     EQU $+1
                LD A, #00
                CP C
                JR NC, .ScreenBlockColumn

.ScreenBlockNotFound
                OR A                                                            ; Carry сброшен
                PUSH AF
                SET_PAGE_OBJECT
                POP AF
                RET

.ScreenBlockFound
                SCF
                PUSH AF
                SET_PAGE_OBJECT
                POP AF
                RET

; -----------------------------------------
; определить номер screen block'а по экранной координате
; In:
;   A - координата в пикселях
; Out:
;   A - номер строки/столбца screen block'а (0-3)
; -----------------------------------------
.ScreenBlockIndex
                SUB SCR_WORLD_POS_X << 3
                JR NC, .ScreenBlockInView
                XOR A
                RET

.ScreenBlockInView
                CP 6 << 3
                JR C, .ScreenBlock0
                CP 12 << 3
                JR C, .ScreenBlock1
                CP 18 << 3
                JR C, .ScreenBlock2
                LD A, #03
                RET

.ScreenBlock0   XOR A
                RET
.ScreenBlock1   LD A, #01
                RET
.ScreenBlock2   LD A, #02
                RET

.JumpTable      DW Character.Draw                                               ; OBJECT_CLASS_CHARACTER
                DW Character.Draw                                               ; OBJECT_CLASS_CHARACTER_AI
                DW Simple.Draw                                                  ; OBJECT_CLASS_CONSTRUCTION
                DW .RET                                                         ; OBJECT_CLASS_PROPS
                DW .RET                                                         ; OBJECT_CLASS_INTERACTION
                DW .RET                                                         ; OBJECT_CLASS_PARTICLE
                DW .RET                                                         ; OBJECT_CLASS_DECAL
                DW UI.Draw                                                      ; OBJECT_CLASS_UI

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
