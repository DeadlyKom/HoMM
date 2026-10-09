
                ifndef _MODULE_WORLD_UI_HANDLER_ICON_MODE_
                define _MODULE_WORLD_UI_HANDLER_ICON_MODE_
; -----------------------------------------
; обработчик иконки характеристик
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
Characteristics:LD A, UI_MODE_CHARACTERISTICS
                JP RequestMode
; -----------------------------------------
; обработчик иконки инвентаря
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
Inventory:      LD A, UI_MODE_INVENTORY
                JP RequestMode
; -----------------------------------------
; запрос смены UI режима по нажатию
; In:
;   A - новый режим
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
RequestMode:    ; проверка нажатия клавиши "выбор"
                LD HL, GameState.Input.Value
                BIT SELECT_KEY_BIT, (HL)
                RET Z                                                           ; выход, если клавиша "выбор" не нажата

                ; запрос смены UI режима
                JP UI.Runtime.Request

                endif ; ~_MODULE_WORLD_UI_HANDLER_ICON_MODE_
