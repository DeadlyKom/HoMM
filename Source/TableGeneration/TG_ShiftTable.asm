                ifndef _TABLE_GENERATION_SHIFT_TABLE_
                define _TABLE_GENERATION_SHIFT_TABLE_

                module Tables
; -----------------------------------------
; генерация таблицы сдвигов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
TG_ShiftTable:  ;
                LD DE, Adr.ShiftTable
                LD BC, #0007

.ShiftLoop      LD H, #00
                LD A, B
                NEG
                LD L, A

                LD A, 7
                SUB C
                LD (.Jump), A
.Jump           EQU $+1
                JR NZ, $
                ADD HL, HL  ; << 1
                ADD HL, HL  ; << 2
                ADD HL, HL  ; << 3
                ADD HL, HL  ; << 4
                ADD HL, HL  ; << 5
                ADD HL, HL  ; << 6
                ADD HL, HL  ; << 7

                EX DE, HL
                LD (HL), D
                INC H
                LD (HL), E
                DEC H
                INC L
                EX DE, HL
                
                DJNZ .ShiftLoop
                INC D
                INC D

                DEC C
                JR NZ, .ShiftLoop

                RET

                display " - Shift table generator:\t\t\t\t", /A, TG_ShiftTable, "\t= busy [ ", /D, $-TG_ShiftTable, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_SHIFT_TABLE_
