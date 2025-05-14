
                ifndef _WORLD_RENDER_OBJECT_HERO_DRAW_
                define _WORLD_RENDER_OBJECT_HERO_DRAW_
; -----------------------------------------
; отображение объекта "герой"
; In:
;   IY - адрес структуры объекта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ;
                LD HL, Indexes

                ; расчёт адреса структуры FSpritesRef
                LD A, (HL)
                ADD A, A    ; x2
                LD L, A
                EX AF, AF'
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                LD E, (HL)                                                      ; FSpritesRef.Num
                                                                                ; флаг SPRITE_REF_BIT должен быть очищен
                                                                                ; флаг SPRITE_CS_BIT должен присутствовать

                EX AF, AF'
                LD A, #00
                CALL Draw.Sprite
                RET

                endif ; ~_WORLD_RENDER_OBJECT_HERO_DRAW_
