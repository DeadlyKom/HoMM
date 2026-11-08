
                ifndef _MACRO_GAME_BATTLE_MODULE_
                define _MACRO_GAME_BATTLE_MODULE_
; -----------------------------------------
; инициализация главного рендера "битвы"
; In:
; Out:
; Corrupt:
;   BC
; -----------------------------------------
SET_BATTLE_RENDER macro Func?
                LD BC, Func?
                LD (Battle.SharedCode.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_GAME_BATTLE_MODULE_
