
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
                JP SetPage

                endif ; ~_FUNCTIONS_POP_PAGE_
