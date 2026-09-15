
                ifndef _MODULE_WORLD_UI_COMPLETE_LAYER_GAME_VIEW_
                define _MODULE_WORLD_UI_COMPLETE_LAYER_GAME_VIEW_
; -----------------------------------------
; завершение перехода UI слоя "игрового окна"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
Layer_GameView: ; проверка запроса перехода к характеристикам
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                CP UI_MODE_CHARACTERISTICS
                JP NZ, UI.Runtime.Complete                                      ; переход, если запрошен другой UI режим

                ; запрос завершения главного цикла мира
                SET_MAIN_FLAG ML_EXIT_BIT

                ; завершение перехода UI
                JP UI.Runtime.Complete

                endif ; ~_MODULE_WORLD_UI_COMPLETE_LAYER_GAME_VIEW_
