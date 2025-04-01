                ifndef _TABLE_GENERATION_SCREEN_ADDRESS_
                define _TABLE_GENERATION_SCREEN_ADDRESS_

                module Tables
; -----------------------------------------
; генерация адресов экрана (строк)
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
TG_ScrAdr:      ; -----------------------------------------
                ; проход по вертикали
                ; -----------------------------------------
                
                LD HL, Adr.ScrAdrTable
                LD DE, #38C0                                                    ; константы
                LD B, E

.RowLoop        ; расчёт младший байт
                LD A, L
                AND D
                ADD A, A
                ADD A, A
                LD (HL), A

                INC H

                ; расчёт старший байт
                LD A, L
                AND E
                RRA
                RRA
                RRA
                XOR L
                AND D
                XOR L
                OR E
                LD (HL), A

                ; преобразование адресов экрана в атрибутные
                PUSH HL
                ; корректировка для теневого экрана
                LD L, A
                RRA
                RRA
                RRA
                AND #03
                OR #D8
                LD H, HIGH Adr.ScrAttrAdrTable
                LD (HL), A
                ; корректировка для основного экрана
                RES 7, L
                RES 7, A
                LD (HL), A
                POP HL

                DEC H
                INC L
                DJNZ .RowLoop

                ; -----------------------------------------
                ; проход по горизонтали
                ; -----------------------------------------

                LD HL, Adr.ScrAdrTable + 0x200
                LD BC, #0000
.ColumnLoop     ;
                LD A, C
                RRA
                RRA
                RRA
                AND %00011111
                LD (HL), A
                INC H

                ; преобразование номера бита в пиксель
                LD A, C
                CPL
                AND #07
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                OR %11000111                                                    ; SET 0, A
                LD (.SetBit), A

                XOR A
.SetBit         EQU $+1
                SET 0, A
                LD (HL), A

                ; следующий элемент
                DEC H
                INC L
                INC C
                DJNZ .ColumnLoop

                RET

                display "\t- Screen address table generator:\t\t", /A, TG_ScrAdr, "\t= busy [ ", /D, $-TG_ScrAdr, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_SCREEN_ADDRESS_
