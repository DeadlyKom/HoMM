
                ifndef _FUNCTIONS_POP_PAGE_
                define _FUNCTIONS_POP_PAGE_
; -----------------------------------------
; востановление страницы
; In:
;   SP+0 - адрес страницы
; Out:
; Corrupt:
;   BC, AF, AF'
; Note:
; -----------------------------------------
PopPage:        POP AF                                                          ; восстановление номера страницы из стека
                JP_PAGE_A

                ; ToDo заменить функцию на SetPageStack

                endif ; ~_FUNCTIONS_POP_PAGE_
