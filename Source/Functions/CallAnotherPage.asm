
                ifndef _FUNCTIONS_CALL_ANOTHER_PAGE_
                define _FUNCTIONS_CALL_ANOTHER_PAGE_
; -----------------------------------------
; вызов функции в другой странице
; In:
;   HL - адрес функции
;   A  - номер страницы
; Out:
; Corrupt:
;   BC, AF, AF'
; Note:
; -----------------------------------------
CallAnotherPage EX AF, AF'
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                LD BC, Func.PopPage
                PUSH BC
                PUSH HL
                EX AF, AF'
                JP SetPage

                endif ; ~_FUNCTIONS_CALL_ANOTHER_PAGE_
