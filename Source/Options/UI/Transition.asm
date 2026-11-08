
                ifndef _OPTIONS_UI_TRANSITION_
                define _OPTIONS_UI_TRANSITION_

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
World:          ; вызов кода из модуля "опций"
                JP Options.UI.Transition.World
                endmodule

                endif ; ~_OPTIONS_UI_TRANSITION_
