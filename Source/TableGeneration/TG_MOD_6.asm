                ifndef _TABLE_GENERATION_MOD_6_TABLE_
                define _TABLE_GENERATION_MOD_6_TABLE_

                module Tables
; -----------------------------------------
; генерация таблицы mod 6 числа 0-21
; In:
;   HL - адрес таблицы выровнен 256 байт!
; Out:
; Corrupt:
; Note:
; -----------------------------------------
TG_Mod6Table:   ; инициализация генерации
                ; LD HL, Adr.Mod6Table
                XOR A
                LD BC, SCR_WORLD_SIZE_Y << 8
.Loop           CP 6
                JR C, $+4
                INC C
                XOR A
                LD (HL), C
                INC L
                INC A
                DJNZ .Loop

                RET

                display " - Generate table mod 6:\t\t\t\t", /A, TG_BitScanLsbTable, "\t= busy [ ", /D, $-TG_BitScanLsbTable, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_MOD_6_TABLE_
