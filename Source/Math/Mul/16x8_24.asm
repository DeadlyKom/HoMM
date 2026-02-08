
                ifndef _MATH_MULTIPLY_INTEGER_16x8_24
                define _MATH_MULTIPLY_INTEGER_16x8_24

                module Math
; -----------------------------------------
; умножение DE на A
; In :
;   DE - множимое
;   A  - множитель
; Out :
;   AHL - результат умножения DE * A
; Corrupt :
;   HL, AF
; Note:
;   http://map.grauw.nl/sources/external/z80bits.html#1.2
; -----------------------------------------
Mul16x8_24:     LD HL, #0000
                ADD A, A
                JR NC, $+4+1                                                    ; пропустим ADD HL, HL т.к. HL равен нулю, сдвиг не требуется
                LD H, D
                LD L, E
                
                ; unroll
                rept 7
                ADD HL, HL
                ADC A, A
                JR NC, $+5
                ADD HL, DE
                ADC A, #00
                endr
                
                RET

                display " - Multiply 16x8_24:\t\t\t\t\t", /A, Mul16x8_24, "\t= busy [ ", /D, $-Mul16x8_24, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_MULTIPLY_INTEGER_16x8_24
