
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
Draw:           LD HL, .Delay
                DEC (HL)
                JR NZ, .L1

                LD (HL), #02


                LD HL, .Counter
                LD A, (HL)
                INC A
                AND #07
                LD (HL), A

                ;
.L1             LD HL, Indexes

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
                LD A, (.Counter)
                CALL Draw.Sprite
                RET

.Counter        DB #00
.Delay          DB #02

                endif ; ~_WORLD_RENDER_OBJECT_HERO_DRAW_
