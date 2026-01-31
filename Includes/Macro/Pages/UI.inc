                ifndef _MACRO_PAGE_UI_
                define _MACRO_PAGE_UI_
; -----------------------------------------
; включить страницу работы с UI
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_PAGE_UI     macro
                SET_PAGE_3
                endm

                endif ; ~_MACRO_PAGE_UI_
