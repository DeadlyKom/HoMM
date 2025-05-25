                ifndef _MACRO_PAGE_PATHFINDING_
                define _MACRO_PAGE_PATHFINDING_
; -----------------------------------------
; включить страницу работы с поиском пути
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_PAGE_PATHFINDING macro
                SET_PAGE_3
                endm

                endif ; ~_MACRO_PAGE_PATHFINDING_
