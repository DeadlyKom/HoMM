                ifndef _MACRO_PAGE_WORLD_
                define _MACRO_PAGE_WORLD_
; -----------------------------------------
; включить страницу работы с картой "мира"
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_PAGE_WORLD  macro
                SET_PAGE_0
                endm

                endif ; ~_MACRO_PAGE_WORLD_
