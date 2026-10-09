
                ifndef _MODULE_INVENTORY_INPUT_EXIT_
                define _MODULE_INVENTORY_INPUT_EXIT_
; -----------------------------------------
; событие ввода - 'выход'
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
Input.Exit      ; запрос возврата в мир
                LD A, UI_MODE_WORLD
                JP UI.Runtime.Request

                endif ; ~_MODULE_INVENTORY_INPUT_EXIT_
