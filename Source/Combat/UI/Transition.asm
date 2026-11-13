
                ifndef _COMBAT_UI_TRANSITION_
                define _COMBAT_UI_TRANSITION_

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
World:          ; вызов кода из модуля "сражения"
                JP Combat.UI.Transition.World
                endmodule

                endif ; ~_COMBAT_UI_TRANSITION_
