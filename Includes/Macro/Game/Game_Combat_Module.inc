
                ifndef _MACRO_GAME_COMBAT_MODULE_
                define _MACRO_GAME_COMBAT_MODULE_
; -----------------------------------------
; инициализация главного рендера "сражения"
; In:
; Out:
; Corrupt:
;   BC
; -----------------------------------------
SET_COMBAT_RENDER macro Func?
                LD BC, Func?
                LD (Combat.SharedCode.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_GAME_COMBAT_MODULE_
