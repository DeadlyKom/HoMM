
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

                ; установка запроса перерисовки фона
                LD HL, Inventory.States.HoveredItem.Flags
                SET INVENTORY_REDRAW_BIT, (HL)
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после изменения состояния слота
                RET

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_RESET_HOVER_ITEM_
