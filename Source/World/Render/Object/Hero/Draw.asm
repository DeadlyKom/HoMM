
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
                LD (HL), #01

                LD HL, .Counter
                LD A, (HL)
                INC A
                AND #07
                LD (HL), A

                LD A, (.Step)
                LD C, A
                ADD A, A
                SBC A, A
                LD B, A

                LD HL, (IY + FObject.Position.X)
                ADD HL, BC
                LD (IY + FObject.Position.X), HL

                LD HL, .StepCount
                DEC (HL)
                JR NZ, .L1

                LD (HL), #20

                LD A, (.Step)
                NEG
                LD (.Step), A

                ;
                LD HL, .Index
                INC (HL)
                LD A, (HL)
                CP 9
                JR NZ, .L1
                LD (HL), 0

.L1             LD HL, Indexes

                LD A, (.Index)
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

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

.Counter        DB #06
.Delay          DB #02

.Step           DB #10
.StepCount      DB #70

.Index          DB #00
.IndexStep      DB #01

                endif ; ~_WORLD_RENDER_OBJECT_HERO_DRAW_
