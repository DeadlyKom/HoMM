
                ifndef _MODULE_INVENTORY_LAUNCH_CLEAR_STATE_
                define _MODULE_INVENTORY_LAUNCH_CLEAR_STATE_
; -----------------------------------------
; очистка состояний "инвентаря"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
ClearState:     ; очистка массива состояний слотов будет добавлена после его объявления
                RET

                endif                                                           ; ~_MODULE_INVENTORY_LAUNCH_CLEAR_STATE_
