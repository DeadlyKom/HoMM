
                ifndef _WORLD_RENDER_OBJECT_DRAW_
                define _WORLD_RENDER_OBJECT_DRAW_
; -----------------------------------------
; отображение объектов "мира"
; In:
;   A  - количество объектов в массиве SortBuffer
; Out:
; Corrupt:
; Note:
;   обход SortBuffer начинается с области Decal
;   при переполнении младшего байта адреса обход автоматически продолжается с начала SortBuffer,
;   что позволяет добавлять Decal с конца, а World и UI с начала буфера без перемещения области Decal
; -----------------------------------------
Draw:           ; инициализация
                LD B, A
                LD D, HIGH Adr.SortBuffer                                       ; старший байт адреса SortBuffer
                LD A, (AddObjects.OffsetDecal)                                  ; смещение начала области Decal
                LD E, A                                                         ; адрес первого элемента списка

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; проверка видимости объекта по положению в гексагонах
                OR A                                                            ; сброс флага переполнения перед условной проверкой
                BIT OBJECT_SELF_CALCULATED_POSITION_BIT, (IY + FObject.Flags)
                CALL Z, IsVisible                                               ; проверка видимости объекта
                JR C, .NextObject                                               ; переход, если объект не виден

.CheckRefresh   ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR Z, .ForcedVisibility                                         ; переход, если флаг не установлен,
                                                                                ; но необходимо проверить обновление screen block'а или принудительное обновление
                RES OBJECT_DIRTY_BIT, (IY + FObject.Flags)                      ; сброс флага

.NeedRefresh    PUSH DE
                ; расчёт положения объекта относительно верхнего левого видимого края
                BIT OBJECT_SELF_CALCULATED_POSITION_BIT, (IY + FObject.Flags)
                CALL Z, Utilities.TransformToScr.Store

                ; определение способа отображения объекта
                LD A, (IY + FObjectDefaultSettings.Class)
                AND OBJECT_CLASS_MASK

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                PUSH IY                                                         ; сохранение адреса обрабатываемого объекта
                LD HL, .JumpTable
                LD IX, Draw.SpriteClipping
                CALL Func.JumpTable
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                POP IY                                                          ; восстановление адреса обрабатываемого объекта

                ; bound самостоятельно рассчитываемого объекта обновляется внутри его Draw
                BIT OBJECT_SELF_CALCULATED_POSITION_BIT, (IY + FObject.Flags)
                CALL Z, .StoreBound

                ; восстановление адреса обхода SortBuffer
                POP DE
.NextObject     POP BC
                DJNZ .Loop
.RET            RET

.ForcedVisibility; проверка флага принудительного обновления кадра
                CHECK_VIEW_FLAG FORCED_FRAME_UPDATE_BIT
                JR NZ, .NeedRefresh                                             ; переход, если требуется принудительное обновление

                ; проверка обновления screen block'а
                PUSH DE
                CALL BoundScreenBlock.Intersects
                POP DE
                JR C, .NeedRefresh                                              ; переход, если screen block обновляется, необходимо обновить и объект
                JR .NextObject                                                  ; переход, если screen block не обновляется
; -----------------------------------------
; сохранение рассчитанного bound спрайта в объекте
; In:
;   IY - адрес структуры объекта (FObject)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу работы с объектами (страница 0)
; -----------------------------------------
.StoreBound:    LD HL, FObject.Bound
                PUSH IY
                POP DE
                ADD HL, DE
                EX DE, HL                                                       ; DE - адрес FObject.Bound
                LD HL, GameState.SpriteBound                                    ; HL - адрес временного bound
                LDI
                LDI
                LDI
                LDI
                RET

.JumpTable      DW Character.Draw                                               ; OBJECT_CLASS_CHARACTER
                DW Character.Draw                                               ; OBJECT_CLASS_CHARACTER_AI
                DW Simple.Draw                                                  ; OBJECT_CLASS_CONSTRUCTION
                DW .RET                                                         ; OBJECT_CLASS_PROPS
                DW .RET                                                         ; OBJECT_CLASS_INTERACTION
                DW .RET                                                         ; OBJECT_CLASS_PARTICLE
                DW Decal.Draw                                                   ; OBJECT_CLASS_DECAL
                DW UI.Draw                                                      ; OBJECT_CLASS_UI

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
