
                ifndef _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BELT_
                define _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BELT_
; -----------------------------------------
; обработчик OnUpdate UI слоя слота экипировки инвентаря "пояс"
; In:
;   IY - адрес структуры элемента (FUIElement)
;   флаг, переполнения установлен при наведении и сброшен по таймеру подсказки
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Layer_SlotBelt: ; определение предмета в слоте экипировки
                LD E, FCharacter.Equipment.Belt.ID
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot
                JP Inventory.UI.Utilities.SetHoverItem                          ; обновление состояния предмета под курсором
; -----------------------------------------
; обработчик OnMouseEnter слота экипировки инвентаря "пояс"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseEnter   ; сброс флага активного слота при входе курсора
                LD HL, Inventory.States.Slots.Belt
                SET INVENTORY_ACTIVE_SLOT_BIT, (HL)
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после изменения состояния слота
                RET
; -----------------------------------------
; обработчик OnMouseLeave слота экипировки инвентаря "пояс"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseLeave   ; сброс флага активного слота при выходе курсора
                LD HL, Inventory.States.Slots.Belt
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после изменения состояния слота
                JP Inventory.UI.Utilities.ResetHoverItem                        ; сброс идентификатора предмета под курсором

                endif ; ~_MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BELT_
