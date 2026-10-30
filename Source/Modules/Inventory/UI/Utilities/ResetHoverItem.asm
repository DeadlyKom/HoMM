
                ifndef _MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
; -----------------------------------------
; сброс идентификатора предмета под курсором
; In:
; Out:
; Corrupt:
;   AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
ResetHoverItem: ; сброс идентификатора предмета под курсором
                LD A, ITEM_ID_NONE
                LD (Inventory.States.HoveredItem.ID), A
                RET

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
