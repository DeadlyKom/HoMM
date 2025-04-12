
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
                LD (GameSession.WorldInfo + FWorldInfo.StaticObjectNum), A
                LD (GameSession.WorldInfo + FWorldInfo.DynamicObjectNum), A

                ; очистка массива
                MEMSET_BYTE Adr.StaticArray, OBJECT_EMPTY_ELEMENT, Size.StaticArray
                JP_MEMSET_BYTE Adr.DynamicArray, OBJECT_EMPTY_ELEMENT, Size.DynamicArray

                display " - Initialize objects:\t\t\t\t", /A, Initialize, "\t= busy [ ", /D, $-Initialize, " byte(s)  ]"

                endif ; ~_OBJECT_INITIALIZE_
