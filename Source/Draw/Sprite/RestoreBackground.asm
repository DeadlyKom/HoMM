
                ifndef _DRAW_SPRITE_RESTORE_BACKGROUND_
                define _DRAW_SPRITE_RESTORE_BACKGROUND_
; -----------------------------------------
; восстановление фона под спрайтом (только для OR_XOR_SAVE)
; In:
; Out:
; Corrupt:
; Note:
; данные хранящиеся в буфере
;   - адрес экрана
;   - ширина видимой части спрайта в знакоместах
;   - высота видимой части спрайта в пикселях
;   - данные
; -----------------------------------------
Restore:        ; инициализация
                LD HL, Adr.CursorStorageA

                ; 0 байт хранит данные о размере заполнения
                LD A, (HL)
                OR A
                RET Z

                INC L
                LD E, (HL)
                INC L
                LD D, (HL)
.ByScrAdr       INC L

                LD A, (HL)                                                      ; FSize.Width
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
                display " - Draw function 'Restore background':\t\t", /A, Restore, "\t= busy [ ", /D, $-Restore, " byte(s)  ]"

                endif ; ~ _DRAW_SPRITE_RESTORE_BACKGROUND_
