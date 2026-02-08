
                ifndef _MATH_SQRT_
                define _MATH_SQRT_

                module Math
; -----------------------------------------
; расчёт квадратного кореня
; In:
;   HL - значение
; Out:
;   A  - результат
;   HL - остаток 
; Corrupt:
;   HL, DE, AF
; Note:
;   min: 352cc, max: 391cc
;   https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Square_root#Speed_Optimization.2C_preserve_remainder
; -----------------------------------------
Sqrt:           LD DE, #5040
                LD A, H
                SUB E
                JR NC, $+5
                ADD A, E
                LD D, #10

                CP D
                JR C, $+5
                SUB D
                SET 5, D

                RES 4, D
                SRL D
                SET 2, D
                CP D
                JR C, $+5
                SUB D
                SET 3, D
                SRL D

                INC A
                SUB D
                JR NC, $+5
                DEC D
                ADD A, D
                DEC D
                SRL D
                LD H, A

                LD A, E
                SBC HL, DE
                JR NC, $+3
                ADD HL, DE
                CCF
                RRA
                SRL D
                RRA

                LD E, A
                SBC HL, DE
                JR C, $+5
                OR #20
                DB #FE                                                          ; CP*, чтобы не добовлять переход, а просто пропустить следующий байт
                ADD HL, DE
                XOR #18
                SRL D
                RRA

                LD E, A
                SBC HL, DE
                JR C, $+5
                OR #08
                DB #FE                                                          ; CP*, чтобы не добовлять переход, а просто пропустить следующий байт
                ADD HL, DE
                XOR #06
                SRL D
                RRA

                LD E, A
                SBC HL, DE
                JR NC, $+7
                ADD HL, DE
                SRL D
                RRA
                RET

                INC A
                SRL D
                RRA
                RET

                display " - Sqrt:\t\t\t\t\t\t", /A, Sqrt, "\t= busy [ ", /D, $-Sqrt, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_SQRT_
