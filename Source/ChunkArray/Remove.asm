
                ifndef _CHUNK_ARRAY_REMOVE_
                define _CHUNK_ARRAY_REMOVE_
; -----------------------------------------
; удаление значения из массива чанков
; In:
;   A  - порядковый номер чанка [0..127]
;   HL - адрес массива чанков
;   D  - удаляемое значение
;   E  - количество элементов в массиве
; Out:
; Corrupt:
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

                ; HL - начальный адрес счётчиков юнитов в указанном чанке
                ; B  - обнулён
                ; A  - количествой пройденых элементов/начальный адрес расположения элементов

                ifdef _DEBUG
                DEC (HL)
                INC (HL)
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif

                ; уменьшить счётчик
                LD C, (HL)
                DEC (HL)
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
                LD C, A
                LD D, H
                LD E, L
                INC L
                LDIR

                RET

                endif ; ~ _CHUNK_ARRAY_REMOVE_
