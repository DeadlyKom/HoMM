
                ifndef _CHUNK_ARRAY_INSERT_
                define _CHUNK_ARRAY_INSERT_
; -----------------------------------------
; вставка значения в массив чанков
; In:
;   A  - порядковый номер чанка [0..127]
;   HL - адрес массива чанков (выровненый 256 байт) + 0x80
;   D  - добавляемое значение
;   E  - количество элементов в массиве
; Out:
; Corrupt:
;   L, BC, AF
; Note:
; -----------------------------------------
Insert:         ; расчёт начального адреса расположения элемента в указаном чанке
                CALL GetAddress

                ; HL - начальный адрес счётчиков объектов в указанном чанке
                ; B  - обнулён
                ; A  - количествой пройденых элементов/начальный адрес расположения элементов

                ; увеличить счётчик
                INC (HL)

                ; HL - начальный адрес расположения элементов в указанном чанке
                LD L, A

                ; сохранение добовляемое значение
                LD A, D
                EX AF, AF'

                ; проверка 0 элемента
                LD A, E
                OR A
                JR Z, .Set

                ; перенос данных
                SUB L
                JR Z, .Set

                LD C, A
                ADD HL, BC
                LD D, H
                LD E, L
                DEC L
                LDDR
                INC HL

.Set            ; вставка значения
                EX AF, AF'
                LD (HL), A

                RET

                endif ; ~ _CHUNK_ARRAY_INSERT_
