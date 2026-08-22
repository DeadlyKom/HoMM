
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
;   HL, AF
; Note:
;   https://www.smspower.org/Development/DivMod
;
;   если результат деления не помещается в байт
;   значение будет максимально доступное
; -----------------------------------------
DIV_16x8_16     macro           ; тактов: 304-360
                rept 8
                ADD HL, HL
                LD A, H
                JR C, $+5
                CP E
                JR C, $+5
                SUB E
                LD H, A
                INC L
                endr
                endm

Div16x8_16:     DIV_16x8_16
                RET

                display " - Divide 16x8 = 8.8:\t\t\t\t\t", /A, Div16x8_16, "\t= busy [ ", /D, $-Div16x8_16, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_DIVISION_16_8_16_
