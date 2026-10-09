
                ifndef _WORLD_UI_TRANSITION_
                define _WORLD_UI_TRANSITION_

                module Transition
; -----------------------------------------
; переходник к обработчику игрового меню паузы
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Layer_GamePause:; вызов кода из модуля "мира"
                JP World.UI.Transition.Layer_GamePause
; -----------------------------------------
; переходник к обработчику игрового слоя
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Layer_GameView: ; вызов кода из модуля "мира"
                JP World.UI.Transition.Layer_GameView
                endmodule

                endif ; ~_WORLD_UI_TRANSITION_
