
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
                EX AF, AF'
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                LD E, (HL)                                                      ; FSpritesRef.Num
                                                                                ; флаг SPRITE_REF_BIT должен быть очищен
                                                                                ; флаг SPRITE_CS_BIT должен присутствовать
                LD A, (GameState.TickCounter + FTick.Objects)
                
                ; проверка наличия флага SPRITE_CS_BIT
                BIT SPRITE_CS_BIT, E
                JR Z, .SimpleSprite                                             ; переход, если спрайт не является композитным спрайтом

.CompositeSprite; отображение композитного спрайта
                RES SPRITE_CS_BIT, E                                            ; сброс флага

                ; -----------------------------------------
                ; отображение композитного спрайта
                ; In:
                ;   HL - адрес на структуру FSpritesRef
                ;       ; -----------------------------------------
                ;       ;      7    6    5    4    3    2    1    0
                ;       ;   +----+----+----+----+----+----+----+----+
                ;       ;   | 0  | 0  | N5 | N4 | N3 | N2 | N1 | N0 |
                ;       ;   +----+----+----+----+----+----+----+----+
                ;       ;
                ;       ;   N5-N0   [5..0]      - количество спрайтов
                ;       ; -----------------------------------------
                ;   E  - хранит значение FSpritesRef.Num (все флаги обнулены)
                ;   A  - счётчик анимации
                ; -----------------------------------------
                CALL Draw.Composite
                JR .NextDraw

.SimpleSprite   ; отображение простого спрайта
                LD D, A
                ; -----------------------------------------
                ; деление D на E
                ; In:
                ;   D - делимое
                ;   E - делитель
                ; Out:
                ;   D - результат деления   (D / E)
                ;   A - остаток             (D % E)
                ; Corrupt:
                ;   D, AF
                ; Note:
                ;   https://www.smspower.org/Development/DivMod
                ; -----------------------------------------
                CALL Math.Div8x8                                                ; mod
                LD E, A
                EX AF, AF'
                LD A, E
                CALL Draw.Sprite

.NextDraw       POP BC
                POP DE

                DJNZ .Loop
                RET

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
