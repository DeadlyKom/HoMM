
                ifndef _MACRO_GAME_INVENTORY_MODULE_
                define _MACRO_GAME_INVENTORY_MODULE_
; -----------------------------------------
; инициализация главного рендера "инвентаря"
; In:
; Out:
; Corrupt:
;   BC
; -----------------------------------------
SET_INVENTORY_RENDER macro Func?
                LD BC, Func?
                LD (Inventory.SharedCode.Loop.FuncDraw), BC
                endm

                endif ; ~_MACRO_GAME_INVENTORY_MODULE_
