
                ifndef _MATH_RAND_8
                define _MATH_RAND_8

                module Math
; -----------------------------------------
; set 16-bit seed
; In :
;   BC - seed
; Out :
; Corrupt :
;   HL
; Note:
; -----------------------------------------
SetSeed16:      LD HL, Rand8.Table
                LD (HL), C
                INC L
                LD (HL), B
                INC L
                LD (HL), #52
                INC L
                LD (HL), #61
                INC L
                LD (HL), #78
                INC L
                LD (HL), #6F
                INC L
                LD (HL), #66
                INC L
                LD (HL), #74
                INC L
                LD (HL), #14
                INC L
                LD (HL), #0F

                RET
; -----------------------------------------
; set 32-bit seed
; In :
;   DEHL - seed
; Out :
; Corrupt :
;   HL
; Note:
; -----------------------------------------
SetSeed32:      LD B, H
                LD C, L

                LD HL, Rand8.Table
                LD (HL), D
                INC L
                LD (HL), E
                INC L
                LD (HL), B
                INC L
                LD (HL), C
                INC L
                LD (HL), #78
                INC L
                LD (HL), #6F
                INC L
                LD (HL), #66
                INC L
                LD (HL), #74
                INC L
                LD (HL), #14
                INC L
                LD (HL), #0F

                RET
; -----------------------------------------
; set 80-bit seed
; In :
;   HLHL' - пакет 1
;   DEDE' - пакет 2
;   BC - seed
; Out :
; Corrupt :
;   IY
; Note:
; -----------------------------------------
SetSeed80:      PUSH IY
                LD IY, Rand8.Table
                LD (IY + 0), C
                LD (IY + 1), B
                LD (IY + 2), H
                LD (IY + 3), L
                LD (IY + 4), D
                LD (IY + 5), E
                EXX
                LD (IY + 6), H
                LD (IY + 7), L
                LD (IY + 8), D
                LD (IY + 9), E
                EXX
                POP IY
                RET
; -----------------------------------------
; сохранить состояние таблицы генерации
; In :
;   BC - seed
; Out :
; Corrupt :
;   HL
; Note:
; -----------------------------------------
PushSeed:       POP HL
                LD (.RET), HL

                POP HL                                                          ; получить вызываюмую функции главного цикла
                LD (.MainLoopCALL), HL

                LD HL, Rand8.Table
                rept 4
                LD E, (HL)
                INC L
                LD D, (HL)
                INC L
                PUSH DE
                endr

                LD E, (HL)
                INC L
                LD D, (HL)
                PUSH DE

.MainLoopCALL   EQU $+1
                LD HL, #0000
                PUSH HL

.RET            EQU $+1
                JP #0000
; -----------------------------------------
; восстановить состояние таблицы генерации
; In :
;   BC - seed
; Out :
; Corrupt :
;   HL
; Note:
; -----------------------------------------
PopSeed:        POP HL
                LD (.RET), HL

                POP HL                                                          ; получить вызываюмую функции главного цикла
                LD (.MainLoopCALL), HL

                LD HL, Rand8.Table
                rept 4
                POP DE
                LD (HL), E
                INC L
                LD (HL), D
                INC L
                endr

                POP DE
                LD (HL), E
                INC L
                LD (HL), D

.MainLoopCALL   EQU $+1
                LD HL, #0000
                PUSH HL

.RET            EQU $+1
                JP #0000
; -----------------------------------------
; 8-битный генератор случайных чисел
; In :
; Out :
;   A - случайное число
; Corrupt :
;   HL, DE, BC, AF
; Note:
;   https://gist.github.com/raxoft/2275716fea577b48f7f0
; -----------------------------------------
Rand8:          LD HL, .Table

                LD A, (HL)          ; i = (i & 7) + 1
                AND #07
                INC A
                LD (HL), A

                INC L               ; hl = &cy

                LD D, H             ; de = &q[i]
                ADD A, L
                LD E, A

                LD A, (DE)          ; y = q[i]
                LD B, A
                LD C, A
                LD A, (HL)          ; ba = 256 * y + cy

                SBC C               ; ba = 255 * y + cy
                JR NC,$+3
                DEC B

                SUB C               ; ba = 254 * y + cy
                JR NC,$+3
                DEC B

                SUB C               ; ba = 253 * y + cy
                JR NC,$+3
                DEC B

                LD (HL), B          ; cy = ba >> 8, x = ba & 255
                CPL                 ; x = (b-1) - x = -x - 1 = ~x + 1 - 1 = ~x
                LD (DE), A          ; q[i] = x

                RET

.Table          DB #00, #00, #52, #61, #78, #6F, #66, #74, #14, #0F

                if (Rand8.Table >> 8) - ((Rand8.Table + 9) >> 8)
                error "whole table must be within single 256 byte block"
                endif

                display " - RNG 8-bit: \t\t\t\t\t", /A, Rand8, "\t= busy [ ", /D, $ - Rand8, " byte(s)  ]"

                endmodule

                endif ; ~_MATH_RAND_8
