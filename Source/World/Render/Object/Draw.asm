
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
Draw:           ;
                LD B, A
                DEC E

                ; установка отсечение спрайтов
                LD HL, (SCR_WORLD_SIZE_X * 2 - 1) << 8 | (SCR_WORLD_POS_X << 3) ; LeftEdge      - левая грань видимой части     (в пикселах)
                                                                                ; VisibleWidth  - ширина видимой части          (в знакоместах)
                LD (GameState.LeftEdge), HL
                LD HL, ((SCR_WORLD_SIZE_Y << 3) << 9)  | (SCR_WORLD_POS_Y << 3) ; TopEdge       - верхняя грань видимой части   (в пикселах)
                                                                                ; VisibleHeight - высота видимой части          (в пикселах)
                LD (GameState.TopEdge), HL

.Loop           ;
                LD A, (DE)
                LD IYH, A
                DEC E
                LD A, (DE)
                LD IYL, A
                DEC E

                PUSH DE
                PUSH BC

                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"

                ;
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                LD B, A
                LD C, #00
                SRL B
                RR C
                LD HL, (IY + FObject.Position.X)
                SBC HL, BC
                LD BC, SCR_WORLD_POS_X << 7
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipped.PositionX), HL

                ;
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                LD B, A
                LD C, #00
                SRL B
                RR C
                LD HL, (IY + FObject.Position.Y)
                SBC HL, BC
                LD BC, SCR_WORLD_POS_Y << 7
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipped.PositionY), HL

                LD A, (IY + FObject.Sprite)
                ADD A, A    ; x2
                LD L, A
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                CALL Draw.Sprite

                POP BC
                POP DE

                DJNZ .Loop
                RET

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
