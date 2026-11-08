
                ifndef _MACRO_GAME_OPTIONS_MODULE_
                define _MACRO_GAME_OPTIONS_MODULE_
; -----------------------------------------
; инициализация главного рендера "опций"
; In:
; Out:
; Corrupt:
;   BC
; -----------------------------------------
SET_OPTIONS_RENDER macro Func?
                LD BC, Func?
                LD (Options.SharedCode.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_GAME_OPTIONS_MODULE_
