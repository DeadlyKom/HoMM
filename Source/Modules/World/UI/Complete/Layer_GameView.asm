
                ifndef _MODULE_WORLD_UI_COMPLETE_LAYER_GAME_VIEW_
                define _MODULE_WORLD_UI_COMPLETE_LAYER_GAME_VIEW_
; -----------------------------------------
; завершение перехода UI слоя "игрового окна"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
Layer_GameView: ; выбор обработчика завершения по запрошенному UI режиму
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD HL, .JumpTable
                JP Func.JumpTable

.Transition     SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла мира
                JP UI.Runtime.Complete                                          ; завершение перехода UI

.JumpTable      DW UI.Runtime.Complete                                          ; UI_MODE_NONE
                DW .Transition                                                  ; UI_MODE_CHARACTERISTICS
                DW .Transition                                                  ; UI_MODE_INVENTORY
                DW UI.Runtime.Complete                                          ; UI_MODE_SPELLBOOK
                DW UI.Runtime.Complete                                          ; UI_MODE_MAP
                DW UI.Runtime.Complete                                          ; UI_MODE_QUEST_LOG
                DW UI.Runtime.Complete                                          ; UI_MODE_SETTINGS
                DW UI.Runtime.Complete                                          ; UI_MODE_GAME_PAUSE
                DW UI.Runtime.Complete                                          ; UI_MODE_WORLD
                DW UI.Runtime.Complete                                          ; UI_MODE_BATTLE

                endif ; ~_MODULE_WORLD_UI_COMPLETE_LAYER_GAME_VIEW_
