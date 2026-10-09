
                ifndef _MACRO_GAME_CHARACTERISTICS_
                define _MACRO_GAME_CHARACTERISTICS_
; -----------------------------------------
; инициализация главного рендера "характеристик"
; In:
; Out:
; Corrupt:
;   BC
; -----------------------------------------
SET_CHARACTERISTICS_RENDER macro Func?
                LD BC, Func?
                LD (Characteristics.SharedCode.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_GAME_CHARACTERISTICS_
