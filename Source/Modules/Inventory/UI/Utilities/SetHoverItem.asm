
                ifndef _MODULE_INVENTORY_UI_UTILITIES_SET_HOVER_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_SET_HOVER_ITEM_
; -----------------------------------------
; обновление состояния предмета под курсором
; In:
;   E  - идентификатор предмета или ITEM_ID_NONE
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
SetHoverItem:   ; проверка отсутствия предмета под курсором
                LD A, E
                CP ITEM_ID_NONE
                JP Z, ResetHoverItem                                            ; переход, если предмет под курсором отсутствует

                ; проверка изменения идентификатора предмета под курсором
                LD A, (Inventory.States.HoveredItem.ID)
                CP E
                RET Z                                                           ; выход, если идентификатор предмета не изменился

                ; обновление идентификатора предмета под курсором
                LD A, E
                LD (Inventory.States.HoveredItem.ID), A

                ; установка запросов перерисовки фона и рисования описания
                LD HL, Inventory.States.HoveredItem.Flags
                SET_OR_FLAGS INVENTORY_REDRAW | INVENTORY_DESCRIPTION
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после изменения состояния слота
                RET

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_SET_HOVER_ITEM_
