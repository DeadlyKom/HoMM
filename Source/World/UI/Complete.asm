
                ifndef _WORLD_UI_COMPLETE_
                define _WORLD_UI_COMPLETE_

                module Complete
; -----------------------------------------
; переходник к обработчику завершения UI мира
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Layer_GameView: ; постоянная точка входа для завершения UI мира
                ; вызов кода из модуля "мира"
                JP World.UI.Complete.Layer_GameView
                endmodule

                endif ; ~_WORLD_UI_COMPLETE_
