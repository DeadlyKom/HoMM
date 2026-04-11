
                ifndef _STATE_TREE_INITIALIZE_
                define _STATE_TREE_INITIALIZE_
; -----------------------------------------
; инициализация работы с AI-контекстом
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; -----------------------------------------
Initialize:     ; сброс количества элементов в массиве
                XOR A
                LD (GameSession.WorldInfo + FWorldInfo.AIContextNum), A
                
                ; очистка массива (первая, т.к. счётчик элементов в конце массива размещён)
                JP_MEMSET_BYTE Adr.AIContextArray, STATE_TREE_EMPTY_ELEMENT, Size.AIContextArray

                display " - Initialize 'state tree':\t\t\t\t", /A, Initialize, "\t= busy [ ", /D, $-Initialize, " byte(s)  ]"

                endif ; ~_STATE_TREE_INITIALIZE_
