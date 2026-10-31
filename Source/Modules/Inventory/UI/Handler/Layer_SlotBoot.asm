
                ifndef _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BOOT_
                define _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BOOT_
; -----------------------------------------
; обработчик OnUpdate UI слоя слота экипировки инвентаря "обувь"
; In:
;   IY - адрес структуры элемента (FUIElement)
;   флаг, переполнения установлен при наведении и сброшен по таймеру подсказки
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Layer_SlotBoot: ; определение предмета в слоте экипировки
                LD E, FCharacter.Equipment.Boot.ID
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot
                JP Inventory.UI.Utilities.SetHoverItem                          ; обновление состояния предмета под курсором
; -----------------------------------------
; обработчик OnMouseEnter слота экипировки инвентаря "обувь"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseEnter   ; сброс флага активного слота при входе курсора
                LD HL, Inventory.States.Slots.Boot
                SET INVENTORY_ACTIVE_SLOT_BIT, (HL)
                RET
; -----------------------------------------
; обработчик OnMouseLeave слота экипировки инвентаря "обувь"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseLeave   ; сброс флага активного слота при выходе курсора
                LD HL, Inventory.States.Slots.Boot
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                JP Inventory.UI.Utilities.ResetHoverItem                        ; сброс идентификатора предмета под курсором

                endif ; ~_MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BOOT_
