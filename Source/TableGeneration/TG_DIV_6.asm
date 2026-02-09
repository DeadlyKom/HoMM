                ifndef _TABLE_GENERATION_DIV_6_TABLE_
                define _TABLE_GENERATION_DIV_6_TABLE_

                module Tables
; -----------------------------------------
; генерация таблицы деления N на 6 
; In:
;   HL - адрес таблицы выровнен 256 байт!
;   B  - делимое
; Out:
; Corrupt:
; Note:
; -----------------------------------------
TG_Div6Table:   ; инициализация генерации
                ; LD HL, Adr.Div6Table
                XOR A
                LD C, A
.Loop           CP 6
                JR C, $+4
                INC C
                XOR A
                LD (HL), C
                INC L
                INC A
                DJNZ .Loop

                RET

                display " - Generate table div 6:\t\t\t\t\t\t= busy [ ", /D, $-TG_Div6Table, " byte(s) ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_DIV_6_TABLE_
