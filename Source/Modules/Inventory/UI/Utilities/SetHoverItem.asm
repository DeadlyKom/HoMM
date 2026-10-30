
                ifndef _MODULE_INVENTORY_UI_UTILITIES_SET_HOVER_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_SET_HOVER_ITEM_
; -----------------------------------------
; обновление состояния предмета под курсором
; In:
;   E  - идентификатор предмета или ITEM_ID_NONE
; Out:
; Corrupt:
;   AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
SetHoverItem:   ; запись идентификатора предмета под курсором
                LD A, E
                LD (Inventory.States.HoveredItem.ID), A
                RET

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_SET_HOVER_ITEM_
