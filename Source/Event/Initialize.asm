
                ifndef _EVENT_INITIALIZE_
                define _EVENT_INITIALIZE_
; -----------------------------------------
; инициализация работы с событиями
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 7)
; -----------------------------------------
Initialize:     ; сброс количества элементов в массиве
                XOR A
                LD (GameSession.WorldInfo + FWorldInfo.EventNum), A

                ; очистка массива
                JP_MEMSET_BYTE Adr.EventArray, EVENT_EMPTY_ELEMENT, Size.EventArray

                display " - Initialize 'event':\t\t\t\t", /A, Initialize, "\t= busy [ ", /D, $-Initialize, " byte(s)  ]"

                endif ; ~_EVENT_INITIALIZE_
