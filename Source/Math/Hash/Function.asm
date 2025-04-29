
                ifndef _MATH_HASH_FUNCTION_
                define _MATH_HASH_FUNCTION_

                module Math
; -----------------------------------------
; получение хеш значения из строки
; In:
;   HL   - адрес строки
; Out:
;   DEHL - хеш-значение
; Corrupt:
;   HL, AF, HL', DE', BC', AF'
; Note:
;   Хеш-функция №8: GNU
;   https://habr.com/ru/articles/732542/
; -----------------------------------------
Hash.Function:  ; инициализация
                EXX

                ; стартовое значение
                LD HL, #A55A
                LD DE, #5AA5

.Loop           EXX
                
                ; чтение символа
                LD A, (HL)
                INC HL
                OR A

                EXX
                RET Z                                                           ; выход, если конец строки

                ; -----------------------------------------
                ; hash = (hash >> 5 + hash) + value[i];
                ; -----------------------------------------
                PUSH DE
                PUSH HL
                EX AF, AF'                                                      ; сохранение значения

                ; hash >> 5
                LD B, #05
                CALL Math.ROR.x32

                ; hash >> 5 + hash
                POP BC
                ADD HL, BC
                EX DE, HL
                POP BC
                ADC HL, BC
                EX DE, HL

                ; (hash >> 5 + hash) + value[i]
                EX AF, AF'                                                      ; восстановление значения
                LD C, A
                LD B, #00
                ADD HL, BC
                JR NC, $+3
                INC DE

                JR .Loop

                display " - Hash function:\t\t\t\t\t", /A, Hash.Function, "\t= busy [ ", /D, $-Hash.Function, " byte(s)  ]"
                endmodule

                endif ; ~ _CORE_MODULE_OPEN_WORLD_UTILS_GET_HASH_
