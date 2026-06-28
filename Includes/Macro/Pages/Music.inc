                ifndef _MACRO_PAGE_MUSIC_
                define _MACRO_PAGE_MUSIC_
; -----------------------------------------
; включить страницу работы с музыкой
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_PAGE_MUSIC  macro
                SET_PAGE_4
                endm
JP_SET_PAGE_MUSIC macro
                JP_PAGE_4
                endm

                endif ; ~_MACRO_PAGE_MUSIC_
