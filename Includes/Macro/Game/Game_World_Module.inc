
                ifndef _MACRO_GAME_WORLD_MODULE_
                define _MACRO_GAME_WORLD_MODULE_
; -----------------------------------------
; инициализаци главного рендера "мира"
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_WORLD_RENDER macro Func?
                LD BC, Func?
                LD (World.SharedCode.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_GAME_WORLD_MODULE_
