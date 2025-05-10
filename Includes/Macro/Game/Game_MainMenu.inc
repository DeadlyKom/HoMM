
                ifndef _MACRO_MAIN_MENU_
                define _MACRO_MAIN_MENU_
; -----------------------------------------
; инициализаци главного рендера "мира"
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_MAIN_MENU_RENDER macro Func?
                LD BC, Func?
                LD (MainMenu.Base.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_MAIN_MENU_
