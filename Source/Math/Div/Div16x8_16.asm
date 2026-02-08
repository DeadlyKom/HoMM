
                ifndef _MATH_DIVISION_16_8_16_
                define _MATH_DIVISION_16_8_16_

                module Math
; -----------------------------------------
; деление HL на E
; In :
;   HL - делимое
;   E  - делитель
; Out :
;   L  - результат деления
;   H  - остаток                (mod)
; Corrupt :
;   HL, B, AF
; Note:
;   https://www.smspower.org/Development/DivMod
;
;   если результат деления не помещается в байт
;   значение будет максимально доступное
; -----------------------------------------
Div16x8_16:     LD B, #08

.Loop           ADD HL, HL
                LD A, H
                JR C, .Sub
                CP E
                JR C, .Next
.Sub            SUB E
                LD H, A
                INC L
.Next           DJNZ .Loop

                RET

                display " - Divide 16x8 = 8.8:\t\t\t\t\t", /A, Div16x8_16, "\t= busy [ ", /D, $-Div16x8_16, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_DIVISION_16_8_16_
