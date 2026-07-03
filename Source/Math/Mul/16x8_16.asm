
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
MUL_16x8_16     macro           ;   тактов: 204-260
                LD HL, #0000    ; 10

                ; сдвиг нулевого HL не требуется.
                RLCA            ; 4
                JR NC, $+4+1    ; 7/12 (пропуск ADD HL, HL)
                LD H, D         ; 4
                LD L, E         ; 4

                ; unroll
                rept 7          ; 27/33
                ADD HL, HL      ; 11
                RLCA            ; 4
                JR NC, $+3      ; 7/12
                ADD HL, DE      ; 11
                endr
                endm
Mul16x8_16:     MUL_16x8_16
                RET             ; не учитывается

                display " - Multiply 16x8_16:\t\t\t\t\t", /A, Mul16x8_16, "\t= busy [ ", /D, $-Mul16x8_16, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_MULTIPLY_INTEGER_16x8_24
