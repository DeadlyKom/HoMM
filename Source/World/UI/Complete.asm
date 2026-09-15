
                ifndef _WORLD_UI_COMPLETE_
                define _WORLD_UI_COMPLETE_

                module Complete
; -----------------------------------------
; переход к обработчику завершения UI мира
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
Layer_GameView: JP World.UI.Complete.Layer_GameView                             ; переход к обработчику завершения
                endmodule

                endif ; ~_WORLD_UI_COMPLETE_
