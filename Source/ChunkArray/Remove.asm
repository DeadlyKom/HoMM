
                ifndef _CHUNK_ARRAY_REMOVE_
                define _CHUNK_ARRAY_REMOVE_
; -----------------------------------------
; удаление значения из массива чанков
; In:
;   A  - порядковый номер чанка
;   HL - адрес счётчиков массива чанков (выровненый 256 байт)
;   D  - удаляемое значение
;   E  - количество элементов в массиве
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
Remove:         ; уменьшение количество элементов в массиве
                DEC E
                RET Z                                                           ; выход, если последний элемент в массиве

                ifdef _DEBUG
                INC E
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                DEC E
                endif

                ; расчёт начального адреса расположения элемента в указаном чанке
                CALL GetAddress

                ; HL - начальный адрес счётчиков в указанном чанке
                ; A  - количествой пройденых элементов/начальный адрес расположения элементов

                ifdef _DEBUG
                DEC (HL)
                INC (HL)
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif

                ; уменьшить счётчик
                LD C, (HL)
                DEC (HL)
                INC H                                                           ; переход на массив значений
                LD L, A
                JR Z, .Memmove

                ; поиск удаляемого значения
                LD A, D
                CPIR
                DEBUG_BREAK_POINT_NZ                                            ; произошла ошибка!
                DEC L

.Memmove        LD A, E
                SUB L
                RET Z                                                           ; выход, если элемент находится в конце

                ; перемещение данных (сокращение) shrink
                LD B, #00
                LD C, A
                LD D, H
                LD E, L
                INC L
                LDIR

                RET

                endif ; ~ _CHUNK_ARRAY_REMOVE_
