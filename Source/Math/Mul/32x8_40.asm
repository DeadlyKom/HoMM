
                ifndef _MATH_MULTIPLY_INTEGER_32x8_40
                define _MATH_MULTIPLY_INTEGER_32x8_40

                module Math
; -----------------------------------------
; умножение DEHL на A
; In :
;   DEHL  - множимое
;   A     - множитель
; Out :
;   AHLDE - резульатат умножения DEHL * A
; Corrupt :
;   HL, DE, B, AF
; Note:
;   http://z80-heaven.wikidot.com/math#toc8
; -----------------------------------------
Mul32x8_40:     ; TODO optimize
                EXX
                PUSH HL
                PUSH DE
                PUSH BC
                EXX

                PUSH HL
                LD HL, #0000        ; hi
                EXX
                LD HL, #0000        ; low
                POP DE

                LD B, #00

                rept 8
                ADD HL, HL          ; low
                EXX
                ADC HL, HL          ; hi
                EXX
                
                ADC A, A
                JR NC, $+8
                ADD HL, DE          ; low
                EXX
                ADC HL, DE          ; hi
                EXX
                ADC A, B
                endr

                PUSH HL
                EXX
                POP DE

                EXX
                POP BC
                POP DE
                POP HL
                EXX

                RET

                display " - Multiply 32x8_40: \t\t\t\t\t", /A, Mul32x8_40, " = busy [ ", /D, $ - Mul32x8_40, " byte(s)  ]"

                endmodule

                endif ; ~_MATH_MULTIPLY_INTEGER_32x8_40