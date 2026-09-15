
                ifndef _MODULE_WORLD_UI_TRANSITION_TO_CHARACTERISTICS_
                define _MODULE_WORLD_UI_TRANSITION_TO_CHARACTERISTICS_
; -----------------------------------------
; переход к UI режиму "характеристики"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
Characteristics:; завершение перехода UI мира
                ; ToDo:
                ;   добавить длительный переход, выполняемый по шагам на тиках UI
                ;   до завершения эффекта возвращать управление в цикл
                ;   переходить в Complete мира только после завершения эффекта
                JP World.UI.Complete.Layer_GameView

                endif ; ~_MODULE_WORLD_UI_TRANSITION_TO_CHARACTERISTICS_
