
                ifndef _MATH_DIVISION_8_8_
                define _MATH_DIVISION_8_8_

                module Math
; -----------------------------------------
; деление D на E
; In:
;   D - делимое
;   E - делитель
; Out:
;   D - результат деления   (D / E)
;   A - остаток             (D % E)
; Corrupt:
;   D, AF
; Note:
;   https://www.smspower.org/Development/DivMod
; -----------------------------------------
Div8x8:         XOR A
                rept 7
                SLA D
                RLA
                CP E
                JR C, $+4
                SUB E
                INC D
                endr
                SLA D
                RLA
                CP E
                RET C
                SUB E
                INC D
                RET

                display " - Divide 8x8:\t\t\t\t\t", /A, Div8x8, " = busy [ ", /D, $ - Div8x8, " byte(s)  ]"

                endmodule

                endif ; ~_MATH_DIVISION_8_8_
