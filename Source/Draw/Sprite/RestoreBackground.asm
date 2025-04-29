
                ifndef _DRAW_SPRITE_RESTORE_BACKGROUND_
                define _DRAW_SPRITE_RESTORE_BACKGROUND_
; -----------------------------------------
; отсечение спрайта с последующим отображение
; In:
;   HL - адрес спрайта FSprite
; Out:
; Corrupt:
; Note:
; данные хранящиеся в буфере
;   - адрес экрана
;   - ширина видимой части спрайта в знакоместах
;   - высота видимой части спрайта в пикселях
;   - данные
; -----------------------------------------
Restore:        ;
                LD HL, Adr.TempBuffer

                LD E, (HL)
                INC L
                LD D, (HL)
                INC L

                LD A, (HL)                                                      ; FSize.Width
                OR A
                RET Z
                INC L
                LD C, (HL)                                                      ; FSize.Height
                INC L

                EX DE, HL

.Loop           LD B, A
                EX AF, AF'
                PUSH HL

.RowLoop        LD A, (DE)
                LD (HL), A
                INC L
                INC E
                DJNZ .RowLoop

                POP HL

                ; классический метод "DOWN HL" 25/59
                INC H
                LD A, H
                AND #07
                JP NZ, $+12
                LD A, L
                SUB #E0
                LD L, A
                SBC A, A
                AND #F8
                ADD A, H
                LD H, A

                EX AF, AF'
                DEC C
                JR NZ, .Loop

                RET

                endif ; ~ _DRAW_SPRITE_RESTORE_BACKGROUND_
