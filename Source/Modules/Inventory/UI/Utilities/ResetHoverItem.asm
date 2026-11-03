
                ifndef _MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
; -----------------------------------------
; сброс идентификатора предмета под курсором
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
ResetHoverItem: ; проверка отсутствия предмета под курсором
                LD A, (Inventory.States.HoveredItem.ID)
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если идентификатор предмета уже сброшен

                ; сброс идентификатора предмета под курсором
                LD A, ITEM_ID_NONE
                LD (Inventory.States.HoveredItem.ID), A

                ; проверка активности перетаскивания
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RET NZ                                                          ; выход, если перетаскивание активно

                ; установка запроса перерисовки фона
                LD HL, Inventory.States.HoveredItem.Flags
                SET INVENTORY_REDRAW_BIT, (HL)
                RET

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
