
                ifndef _MODULE_CHARACTERISTICS_INPUT_NEXT_
                define _MODULE_CHARACTERISTICS_INPUT_NEXT_
; -----------------------------------------
; событие ввода - "переход к следующему"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "характеристик"
; -----------------------------------------
Input.Next      ; запрос перехода в инвентарь
                LD A, UI_MODE_INVENTORY
                JP UI.Runtime.Request

                endif ; ~_MODULE_CHARACTERISTICS_INPUT_NEXT_
