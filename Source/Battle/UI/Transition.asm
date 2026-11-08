
                ifndef _BATTLE_UI_TRANSITION_
                define _BATTLE_UI_TRANSITION_

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
World:          ; вызов кода из модуля "битвы"
                JP Battle.UI.Transition.World
                endmodule

                endif ; ~_BATTLE_UI_TRANSITION_
