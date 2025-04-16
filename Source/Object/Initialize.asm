
                ifndef _OBJECT_INITIALIZE_
                define _OBJECT_INITIALIZE_
; -----------------------------------------
; инициализация работы с объектами
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     ; сброс количества элементов в массиве
                XOR A
                LD (GameSession.WorldInfo + FWorldInfo.ObjectNum), A

                ; очистка массива
                JP_MEMSET_BYTE Adr.ObjectsArray, OBJECT_EMPTY_ELEMENT, Size.ObjectsArray

                display " - Initialize objects:\t\t\t\t", /A, Initialize, "\t= busy [ ", /D, $-Initialize, " byte(s)  ]"

                endif ; ~_OBJECT_INITIALIZE_
