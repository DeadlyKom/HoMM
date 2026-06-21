
                ifndef _MATH_DIVISION_16_16_16_
                define _MATH_DIVISION_16_16_16_

                module Math
; -----------------------------------------
; деление A:C на DE
; In :
;   A:C - делимое
;   DE  - делитель
; Out :
;   A:C - результат деления
;   HL  - остаток               (mod)
; Corrupt :
;   HL, BC, AF
; Note:
;   https://www.smspower.org/Development/DivMod
; -----------------------------------------
Div16x16_16:    LD HL, #0000
                LD B, #10

.Loop           SLL C
                RLA
                ADC HL, HL
                SBC HL, DE
                JR NC, .Next
                ADD HL, DE
                DEC C
.Next           DJNZ .Loop
                RET

                display " - Divide 16x16 = 16.16:\t\t\t\t", /A, Div16x16_16, "\t= busy [ ", /D, $-Div16x16_16, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_DIVISION_16_8_16_
