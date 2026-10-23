
                ifndef _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BOOT_
                define _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BOOT_
; -----------------------------------------
; обработчик OnUpdate UI слоя слота экипировки инвентаря "обувь"
; In:
;   IY - адрес структуры элемента (FUIElement)
;   флаг, переполнения установлен при наведении и сброшен по таймеру подсказки
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Layer_SlotBoot: RET
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
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после изменения состояния слота
                RET
; -----------------------------------------
; обработчик OnMouseLeave слота экипировки инвентаря "обувь"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseLeave   ; сброс флага активного слота при выходе курсора
                LD HL, Inventory.States.Slots.Boot
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после изменения состояния слота
                RET

                endif ; ~_MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_BOOT_
