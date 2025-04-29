
                ifndef _MATH_ROTATE_RIGHT_x32_
                define _MATH_ROTATE_RIGHT_x32_

                module Math
; -----------------------------------------
; прокрутить 32-битное значение вправо
; In:
;   DEHL - 32-битное значение
;   B    - количество раз
; Out:
;   DEHL - прокрученое 32-битное значение N-раз
; Corrupt:
;   HL, DE, B, AF
; Note:
; -----------------------------------------
Rotate.Right:   
.Loop           LD A, L
                RRA
                RR D
                RR E
                RR H
                RR L
                DJNZ .Loop

                RET

                display " - Rotate right:\t\t\t\t\t", /A, Rotate.Right, "\t= busy [ ", /D, $-Rotate.Right, " byte(s)  ]"
                endmodule

                endif ; ~ _MATH_ROTATE_RIGHT_x32_
