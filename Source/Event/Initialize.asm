
                ifndef _EVENT_INITIALIZE_
                define _EVENT_INITIALIZE_
; -----------------------------------------
; инициализация работы с событиями
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     PUSH_PAGE
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                ; сброс количества элементов в массиве
                XOR A
                LD (GameSession.WorldInfo + FWorldInfo.EventNum), A

                ; очистка массива
                MEMSET_BYTE Adr.EventArray, EVENT_EMPTY_ELEMENT, Size.EventArray
                JP_POP_PAGE

                display " - Initialize event:\t\t\t\t\t", /A, Initialize, "\t= busy [ ", /D, $-Initialize, " byte(s)  ]"

                endif ; ~_EVENT_INITIALIZE_
