
                ifndef _MODULE_SESSION_UTILITIES_CRC_8_BIT_
                define _MODULE_SESSION_UTILITIES_CRC_8_BIT_
; -----------------------------------------
; расчёт контрольной суммы 8-битный
; In:
;   HL - адрес блока
;   DE - длина блока
; Out:
;   A  - контрольная сумма
; Corrupt:
; Note:
;   адрес исполнения неизвестен
;   https://tomdalby.com/other/crc.html
; -----------------------------------------
CRC_8:          XOR A
                INC D
                LD C, #07

.ByteLoop       XOR (HL)
                INC HL
                LD B, #08

.RotateLoop     ADD A, A
                JR NC, .NextBit
                XOR C
.NextBit        DJNZ .RotateLoop

                DEC E
                JR NZ, .ByteLoop

                DEC D
                JR NZ, .ByteLoop

                RET

                display " - Utilities CRC 8-bit:\t\t\t\t\t\t     \t= busy [ ", /D, $-CRC_8, " byte(s) ]"

                endif ; ~_MODULE_SESSION_UTILITIES_CRC_8_BIT_
