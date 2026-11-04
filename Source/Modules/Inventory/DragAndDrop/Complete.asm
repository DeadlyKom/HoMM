                ifndef _MODULE_INVENTORY_DRAG_AND_DROP_COMPLETE_
                define _MODULE_INVENTORY_DRAG_AND_DROP_COMPLETE_
; -----------------------------------------
; завершение перетаскивания после размещения предмета
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Complete:       ; завершение перетаскивания и показ обычного курсора
                RES_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RES_RENDER_FLAG CURSOR_HIDDEN_BIT
                LD A, ITEM_ID_NONE
                LD (Inventory.States.DraggedItem.ID), A

                ; обновление предмета под курсором после размещения
                CALL Inventory.UI.Utilities.RefreshHover

                ; запрос перерисовки окна и актуального описания
                LD HL, Inventory.States.HoveredItem.Flags
                SET_OR_FLAGS INVENTORY_REDRAW | INVENTORY_DESCRIPTION
                RET

                endif ; ~_MODULE_INVENTORY_DRAG_AND_DROP_COMPLETE_
