
                ifndef _CHARACTERISTICS_UI_TRANSITION_
                define _CHARACTERISTICS_UI_TRANSITION_

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
World:          ; вызов кода из модуля "характеристик"
                JP Characteristics.UI.Transition.World
                endmodule

                endif ; ~_CHARACTERISTICS_UI_TRANSITION_
