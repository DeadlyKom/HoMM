
                ifndef _MODULE_INVENTORY_INPUT_PREVIOUS_
                define _MODULE_INVENTORY_INPUT_PREVIOUS_
; -----------------------------------------
; событие ввода - "переход к предыдущему"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Input.Previous  ; запрос перехода в характеристики
                LD A, UI_MODE_CHARACTERISTICS
                JP UI.Runtime.Request

                endif ; ~_MODULE_INVENTORY_INPUT_PREVIOUS_
