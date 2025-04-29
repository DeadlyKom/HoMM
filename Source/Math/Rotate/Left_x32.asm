
                ifndef _MATH_ROTATE_LEFT_x32_
                define _MATH_ROTATE_LEFT_x32_

                module Math
; -----------------------------------------
; прокрутить 32-битное значение влево
; In:
;   DEHL - 32-битное значение
;   B    - количество раз
; Out:
;   DEHL - прокрученое 32-битное значение N-раз
; Corrupt:
; Note:
; -----------------------------------------
Rotate.Left:    
.Loop           LD A, D
                ADD A, A
                RL L
                RL H
                RL E
                RL D
                DJNZ .Loop

                RET

                display " - Rotate left:\t\t\t\t\t", /A, Rotate.Left, "\t= busy [ ", /D, $-Rotate.Left, " byte(s)  ]"
                endmodule

                endif ; ~ _MATH_ROTATE_LEFT_x32_
