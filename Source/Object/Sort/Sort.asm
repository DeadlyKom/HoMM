
                ifndef _OBJECT_SORT_OBJECTS_
                define _OBJECT_SORT_OBJECTS_
; -----------------------------------------
; сортировка объектов отображения
; In:
; Out:
;   A - количество объектов в отсортированном массиве
; Corrupt:
; Note:
;  устойчив к прерыванию
; -----------------------------------------
Visible:        ; количество обрабатываемых объектов
                LD A, (GameState.Objects)                                       ; количество элементов в массиве объектов
                OR A
                RET Z                                                           ; выход, если массив пуст
                EX AF, AF'

                ; сброс смещение
                LD HL, Quicksort.Offset
                LD (HL), #00

                CALL Prepare
                ; JP Quicksort

                endif ; ~_OBJECT_SORT_OBJECTS_
