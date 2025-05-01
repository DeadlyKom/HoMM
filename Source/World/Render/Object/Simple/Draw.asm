
                ifndef _WORLD_RENDER_OBJECT_SIMPLE_DRAW_
                define _WORLD_RENDER_OBJECT_SIMPLE_DRAW_
; -----------------------------------------
; отображение простого объекта
; In:
;   IY - адрес структуры объекта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; расчёт адреса структуры FSpritesRef
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
                JP Draw.Composite

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
                JP Draw.Sprite

                endif ; ~_WORLD_RENDER_OBJECT_SIMPLE_DRAW_
