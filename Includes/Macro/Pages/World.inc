                ifndef _MACRO_PAGE_WORLD_
                define _MACRO_PAGE_WORLD_
; -----------------------------------------
; включить страницу работы с картой
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_PAGE_MAP    macro
                SET_PAGE_1
                endm

                endif ; ~_MACRO_PAGE_WORLD_
