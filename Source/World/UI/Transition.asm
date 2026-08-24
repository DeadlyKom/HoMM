
                ifndef _WORLD_UI_TRANSITION_
                define _WORLD_UI_TRANSITION_

                module UI
                module Transition
; -----------------------------------------
; переход к обработчику игрового меню паузы
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GamePause:      JP World.UI.Transition.GamePause                                ; перейти к обработчику перехода
; -----------------------------------------
; переход к обработчику игрового слоя
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWorld:      JP World.UI.Transition.GameWorld                                ; перейти к обработчику перехода

                endmodule
                endmodule

                endif ; ~_WORLD_UI_TRANSITION_
