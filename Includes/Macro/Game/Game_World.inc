
                ifndef _MACRO_WORLD_
                define _MACRO_WORLD_
; -----------------------------------------
; инициализаци главного рендера "мира"
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_WORLD_RENDER macro Func?
                LD BC, Func?
                LD (World.Base.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_WORLD_
