
                ifndef _SPRITE_FIND_GRAPH_HEADER_
                define _SPRITE_FIND_GRAPH_HEADER_
; -----------------------------------------
; поиск графического заголовка
; In:
;   DE - адрес хеша
; Out:
;   HL - адрес найденой структуры FGraphicHeader
;   флаг переполнения Carry сброшен, если поиск удачен
; Corrupt:
; Note:
;   необходимо проинициализировать следующие переменные
;       FindGraphHeader.HeaderNum - количество количество заголовков графики FGraphicHeader
;       FindGraphHeader.HeaderAdr - адрес массива заголовков графики FGraphicHeader
; -----------------------------------------
FindGraphHeader:;
.HeaderNum      EQU $+1
                LD A, #00
                OR A
                CCF
                RET Z

                ; чтение искомого хеша
                EX DE, HL
                LD C, (HL)
                INC HL
                LD B, (HL)
                LD (.Hash), BC
                EX DE, HL

                ; инициализация
                LD B, A
.HeaderAdr      EQU $+1
                LD HL, #0000
                
.Loop           PUSH BC
                PUSH HL
                ; расчёт хеша
                CALL Math.Hash                                                  ; DEHL - хеш-значение
                ADD HL, DE

                ; сравнение хешей
.Hash           EQU $+1
                LD DE, #0000
                OR A
                SBC HL, DE

                POP HL
                POP BC
                RET Z                                                           ; выход, если найдена искомая структура FGraphicHeader

                ; следующий адрес структуры FGraphicHeader
                LD A, FGraphicHeader
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                DJNZ .Loop

                SCF                                                             ; ошибка поиска
                RET

                display " - Sprite find GraphHeader:\t\t\t\t", /A, FindGraphHeader, "\t= busy [ ", /D, $-FindGraphHeader, " byte(s)  ]"

                endif ; ~_SPRITE_FIND_GRAPH_HEADER_
