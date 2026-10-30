
                ifndef _MODULE_INVENTORY_UI_HANDLER_LAYER_GRID_
                define _MODULE_INVENTORY_UI_HANDLER_LAYER_GRID_
; -----------------------------------------
; обработчик OnUpdate UI слоя сетки инвентаря
; In:
;   IY - адрес структуры элемента (FUIElement)
;   флаг, переполнения установлен при наведении и сброшен по таймеру подсказки
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Layer_Grid:     ; определение предмета под курсором
                LD A, (Kernel.Modules.Inventory.Page)
                CALL_IN_PAGE_A Inventory.SharedCode.Utilities.GetItemByCursor.Wrap
                JP Inventory.UI.Utilities.SetHoverItem                          ; обновление состояния предмета под курсором
; -----------------------------------------
; обработчик OnMouseEnter сетки инвентаря
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseEnter   RET
; -----------------------------------------
; обработчик OnMouseLeave сетки инвентаря
; In:
;   IY - адрес структуры элемента (FUIElement)
; Out:
; Corrupt:
;   AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.OnMouseLeave   JP Inventory.UI.Utilities.ResetHoverItem                        ; сброс идентификатора предмета под курсором

                endif ; ~_MODULE_INVENTORY_UI_HANDLER_LAYER_GRID_
