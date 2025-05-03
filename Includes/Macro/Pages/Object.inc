                ifndef _MACRO_PAGE_OBJECT_
                define _MACRO_PAGE_OBJECT_
; -----------------------------------------
; включить страницу работы с объектами
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_PAGE_OBJECT macro
                SET_PAGE_0
                endm

                endif ; ~_MACRO_PAGE_OBJECT_
