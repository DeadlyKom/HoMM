
                ifndef _WORLD_UI_TRANSITION_
                define _WORLD_UI_TRANSITION_

                module Transition
; -----------------------------------------
; переход к обработчику игрового меню паузы
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Layer_GamePause:JP World.UI.Transition.Layer_GamePause                          ; перейти к обработчику перехода
; -----------------------------------------
; переход к обработчику игрового слоя
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Layer_GameView: JP World.UI.Transition.Layer_GameView                           ; перейти к обработчику перехода
                endmodule

                endif ; ~_WORLD_UI_TRANSITION_
