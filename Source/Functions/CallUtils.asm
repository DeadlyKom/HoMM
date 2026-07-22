
                ifndef _FUNCTIONS_CALL_UTILS_
                define _FUNCTIONS_CALL_UTILS_
Call:
; -----------------------------------------
; вызов функции с включением страницы (находясь в странице)
; In:
;   HL - адрес функции
;   A  - номер страницы
; Out:
; Corrupt:
;   BC, AF, AF'
; Note:
; -----------------------------------------
.AnotherPage    EX AF, AF'                                                      ; сохранить номер страницы
                PUSH_PAGE                                                       ; сохранить страницу вызывающего кода
                LD BC, Func.PopPage
                PUSH BC                                                         ; сохранить адрес функции востановления страницы
                PUSH HL                                                         ; сохранение адреса функции
                EX AF, AF'                                                      ; восстановить номер страницы
                JP_SET_PAGE_A                                                   ; включение страниц

                endif ; ~_FUNCTIONS_CALL_UTILS_
