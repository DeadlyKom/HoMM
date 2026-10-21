
                ifndef _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_LEFT_RING_
                define _MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_LEFT_RING_
; -----------------------------------------
; обработчик OnUpdate UI слоя слота экипировки инвентаря "левое кольцо"
; In:
;   IY - адрес структуры элемента (FUIElement)
;   флаг, переполнения установлен при наведении и сброшен по таймеру подсказки
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Layer_SlotLRng: RET
; -----------------------------------------
; обработчик OnMouseEnter слота экипировки инвентаря "левое кольцо"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseEnter   ; сброс флага активного слота при входе курсора
                LD HL, Inventory.States.Slots.LeftRing
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                RET
; -----------------------------------------
; обработчик OnMouseLeave слота экипировки инвентаря "левое кольцо"
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   HL
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseLeave   ; сброс флага активного слота при выходе курсора
                LD HL, Inventory.States.Slots.LeftRing
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                RET

                endif ; ~_MODULE_INVENTORY_UI_HANDLER_LAYER_SLOT_LEFT_RING_
