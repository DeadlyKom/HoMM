
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
                LD HL, (SCR_WORLD_SIZE_X - 1) << 8 | (SCR_WORLD_POS_X << 3)     ; LeftEdge      - левая грань видимой части     (в пикселах)
                                                                                ; VisibleWidth  - ширина видимой части          (в знакоместах)
                LD (GameState.LeftEdge), HL
                LD HL, ((SCR_WORLD_SIZE_Y << 2) << 9)  | (SCR_WORLD_POS_Y << 3) ; TopEdge       - верхняя грань видимой части   (в пикселах)
                                                                                ; VisibleHeight - высота видимой части          (в пикселах)
                LD (GameState.TopEdge), HL

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYH, A
                DEC E
                LD A, (DE)
                LD IYL, A
                DEC E

                PUSH DE
                PUSH BC

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; расчёт положения объекта относительно верхнего-левого видимойго края (по горизонтали)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                LD B, A
                LD C, #00
                SRL B
                RR C
                LD HL, (IY + FObject.Position.X)
                SBC HL, BC
                LD BC, SCR_WORLD_POS_X << 7
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                ; расчёт положения объекта относительно верхнего-левого видимойго края (по вертикали)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                LD B, A
                LD C, #00
                SRL B
                RR C
                LD HL, (IY + FObject.Position.Y)
                SBC HL, BC
                LD BC, SCR_WORLD_POS_Y << 7
                ADD HL, BC
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

.NextDraw       POP BC
                POP DE

                DJNZ .Loop
                RET

.JumpTable      DW Hero.Draw                                                    ; OBJECT_CLASS_HERO
                DW Simple.Draw                                                  ; OBJECT_CLASS_CONSTRUCTION
                DW #0000                                                        ; OBJECT_CLASS_PROPS
                DW #0000                                                        ; OBJECT_CLASS_INTERACTION
                DW #0000                                                        ; OBJECT_CLASS_PARTICLE
                DW #0000                                                        ; OBJECT_CLASS_DECAL
                DW UI.Draw                                                      ; OBJECT_CLASS_UI

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
