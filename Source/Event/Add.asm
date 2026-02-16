
                ifndef _EVENT_ADD_
                define _EVENT_ADD_
; -----------------------------------------
; добавить событие
; In:
; Out:
;   A' - текущий ID события
;   IY - адрес свободного элемента
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   DE, BC, AF, AF'
; Note:
; -----------------------------------------
Add:            PUSH_PAGE
                PUSH HL
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Event.PlacemantNew
                ; размещение нового события
                ; Out:
                ;   A' - текущий ID события
                ;   DE - адрес свободного элемента
                ;   флаг переполнения Carry установлен, если нет свободного места в массиве
                PUSH IY
                POP HL
                ifdef _OPTIMIZE
                rept EVENT_SIZE
                LDI
                endr
                else
                LD BC, EVENT_SIZE
                CALL Memcpy.FastLDIR
                endif
                POP HL
                JP_POP_PAGE

                display " - Add event:\t\t\t\t\t\t", /A, Add, "\t= busy [ ", /D, $-Add, " byte(s)  ]"

                endif ; ~_EVENT_ADD_
