
                ifndef _WORLD_RENDER_OBJECT_DRAW_
                define _WORLD_RENDER_OBJECT_DRAW_
; -----------------------------------------
; отображение объектов "мира"
; In:
;   A  - количество объектов в массиве SortBuffer
;   DE - адрес поледнего элемента
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; инициализация
                LD B, A
                DEC E

                ; установка отсечение спрайтов
                LD HL, (SCR_WORLD_SIZE_X) << 8 | (SCR_WORLD_POS_X << 3)         ; LeftEdge      - левая грань видимой части     (в пикселах)
                                                                                ; VisibleWidth  - ширина видимой части          (в знакоместах)
                LD (GameState.LeftEdge), HL
                LD HL, ((SCR_WORLD_SIZE_Y << 3) << 8)  | (SCR_WORLD_POS_Y << 3) ; TopEdge       - верхняя грань видимой части   (в пикселах)
                                                                                ; VisibleHeight - высота видимой части          (в пикселах)
                LD (GameState.TopEdge), HL

                PUSH BC
                ; расчёт положения карты по горизонтали
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)        ; положение в гексагонах (6)
                ADD A, A    ; x2
                LD C, A
                ADD A, A    ; x4
                ADD A, C    ; x6
                LD B, A
                RR B
                RR C
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)          ; положение в знакоместах
                LD L, #00
                LD H, A
                RR H
                RR L
                ADD HL, BC
                ; LD BC, SCR_WORLD_POS_X << 7
                ; SBC HL, BC
                LD (.MapPositionX), HL

                ; расчёт положения карты по вертикали
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)        ; положение в гексагонах (4)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD H, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)          ; положение в знакоместах
                INC A                                                           ; дополнительное смещение гексагона по вертикали
                ADD A, H
                LD L, #00
                LD H, A
                RR H
                RR L
                LD (.MapPositionY), HL
                POP BC

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYH, A
                DEC E
                LD A, (DE)
                LD IYL, A
                DEC E

                ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR Z, .ForcedVisibility                                          ; переход, если флаг не установлен,
                                                                                ; но необходимо проверить обновление screen block'а или принудительное обновление
                RES OBJECT_DIRTY_BIT, (IY + FObject.Flags)                      ; сброс флага

.NeedRefresh    PUSH DE
                PUSH BC

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                ; расчёт положения объекта относительно верхнего-левого видимойго края (по горизонтали)
                LD A, (IY + FObject.Position.Y.High)
                RRA
                CCF
                SBC A, A
                AND #03
                LD B, A

                LD A, (IY + FObject.Position.X.High)                            ; положение в гексагонах (6)
                ADD A, A    ; x2
                LD C, A
                ADD A, A    ; x4
                ADD A, C    ; x6
                SUB B       ; вычесть смещение по горизонтали в зависимости от чётности строки
                LD C, #00
                LD B, A
                RR B
                RR C
                LD A, (IY + FObject.Position.X.Low)                             ; положение в пикселях, сдвинутое в левую часть (биты 7-3)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, BC
.MapPositionX   EQU $+1
                LD BC, #0000
                SBC HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                ; расчёт положения объекта относительно верхнего-левого видимойго края (по вертикали)
                LD A, (IY + FObject.Position.Y.High)                            ; положение в гексагонах (4)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, #00
                LD B, A
                RR B
                RR C
                LD A, (IY + FObject.Position.Y.Low)                             ; положение в пикселях, сдвинутое в левую часть (биты 7-3)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, BC
.MapPositionY   EQU $+1
                LD BC, #0000
                SBC HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; определение способа отображения объекта
                LD A, (IY + FObjectDefaultSettings.Class)
                AND OBJECT_CLASS_MASK

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                LD HL, .JumpTable
                CALL Func.JumpTable

                POP BC
                POP DE

.NextObject     DJNZ .Loop
                RET

.ForcedVisibility; проверка принудительной видимости
                CHECK_VIEW_FLAG FORCED_FRAME_UPDATE_BIT
                JR NZ, .NeedRefresh                                             ; переход, если требуется принудительное обновление

                ; проверка обновления screen block'а
                ; JR .NeedRefresh                                                 ; переход, если screen block обновляется, необходимо обновить и объект
                JR .NextObject                                                  ; переход, если screen block не обновляется

.JumpTable      DW Hero.Draw                                                    ; OBJECT_CLASS_HERO
                DW Simple.Draw                                                  ; OBJECT_CLASS_CONSTRUCTION
                DW #0000                                                        ; OBJECT_CLASS_PROPS
                DW #0000                                                        ; OBJECT_CLASS_INTERACTION
                DW #0000                                                        ; OBJECT_CLASS_PARTICLE
                DW #0000                                                        ; OBJECT_CLASS_DECAL
                DW UI.Draw                                                      ; OBJECT_CLASS_UI

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
