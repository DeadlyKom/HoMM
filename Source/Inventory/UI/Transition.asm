
                ifndef _INVENTORY_UI_TRANSITION_
                define _INVENTORY_UI_TRANSITION_

                module Transition
; -----------------------------------------
; переходник к обработчику возврата в мир
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
World:          ; вызов кода из модуля "инвентаря"
                JP Inventory.UI.Transition.World
                endmodule

                endif ; ~_INVENTORY_UI_TRANSITION_
