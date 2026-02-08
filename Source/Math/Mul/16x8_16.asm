
                ifndef _MATH_MULTIPLY_INTEGER_16x8_16
                define _MATH_MULTIPLY_INTEGER_16x8_16

                module Math
; -----------------------------------------
; умножение DE на A
; In :
;   DE - множимое
;   A  - множитель
; Out :
;   HL - результат умножения DE * A
; Corrupt :
;   HL, F
; Note:
;   http://z80-heaven.wikidot.com/math#toc1
; -----------------------------------------
Mul16x8_16:     LD HL, #0000

                ; unroll
                rept 8
                ADD HL, HL
                RLCA
                JR NC, $+3
                ADD HL, DE
                endr

                RET

                display " - Multiply 16x8_16:\t\t\t\t\t", /A, Mul16x8_16, "\t= busy [ ", /D, $-Mul16x8_16, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_MULTIPLY_INTEGER_16x8_24
