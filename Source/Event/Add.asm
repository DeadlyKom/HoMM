
                ifndef _EVENT_ADD_
                define _EVENT_ADD_
; -----------------------------------------
; добавить событие
; In:
; Out:
; Corrupt:
;   DE, BC, AF, AF'
; Note:
; Note:
;   добавляемая структура FEvent должна быть сформирована в Adr.EventBuffer
; -----------------------------------------
Add:            PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                PUSH HL
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Event.PlacemantNew
                ; Out:
                ;   A' - текущий ID события
                ;   DE - адрес свободного элемента
                ;   флаг переполнения Carry установлен, если нет свободного места в массиве
                JR C, .RET                                                      ; переход, если ошибка - нет места для размещения события
                
                ; размещение нового события
                LD HL, Adr.EventBuffer
                ifdef _OPTIMIZE
                rept EVENT_SIZE
                LDI
                endr
                else
                LD BC, EVENT_SIZE
                CALL Memcpy.FastLDIR
                endif

.RET            POP HL
                JP_POP_PAGE                                                     ; восстановление номера страницы из стека

                display " - Add event:\t\t\t\t\t\t", /A, Add, "\t= busy [ ", /D, $-Add, " byte(s)  ]"

                endif ; ~_EVENT_ADD_
