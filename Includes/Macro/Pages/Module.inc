                ifndef _MACRO_PAGE_MODULE_
                define _MACRO_PAGE_MODULE_
; -----------------------------------------
; включить страницу модуля "MainMenu"
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_MODULE_PAGE_MainMenu macro
                LD A, (Kernel.Modules.MainMenu.Page)
                SET_PAGE_A
                endm
; -----------------------------------------
; включить страницу модуля "World"
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_MODULE_PAGE_World macro
                LD A, (Kernel.Modules.World.Page)
                SET_PAGE_A
                endm
; -----------------------------------------
; включить страницу модуля "World"
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
JP_SET_MODULE_PAGE_World macro
                LD A, (Kernel.Modules.World.Page)
                JP_SET_PAGE_A
                endm
; -----------------------------------------
; включить страницу модуля "Session"
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
SET_MODULE_PAGE_Session macro
                LD A, (Kernel.Modules.Session.Page)
                SET_PAGE_A
                endm
; -----------------------------------------
; включить страницу модуля "Session"
; In:
; Out:
; Corrupt:
;   BC, AF
; -----------------------------------------
JP_SET_MODULE_PAGE_Session macro
                LD A, (Kernel.Modules.Session.Page)
                JP_SET_PAGE_A
                endm

                endif ; ~_MACRO_PAGE_MODULE_
