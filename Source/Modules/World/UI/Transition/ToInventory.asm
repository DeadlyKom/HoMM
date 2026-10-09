
                ifndef _MODULE_WORLD_UI_TRANSITION_TO_INVENTORY_
                define _MODULE_WORLD_UI_TRANSITION_TO_INVENTORY_
; -----------------------------------------
; переход к UI режиму "инвентарь"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
Inventory:      ; завершение перехода UI мира
                ; ToDo:
                ;   добавить длительный переход, выполняемый по шагам на тиках UI
                ;   до завершения эффекта возвращать управление в цикл
                ;   переходить в Complete мира только после завершения эффекта

                ; прямой вызов завершения внутри модуля "мира"
                ; World.SharedCode.UI.Complete.Layer_GameView предназначен для вызова
                ; из Kernel по постоянному адресу, здесь переходник не требуется
                JP World.UI.Complete.Layer_GameView

                endif ; ~_MODULE_WORLD_UI_TRANSITION_TO_INVENTORY_
