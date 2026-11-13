
                ifndef _MODULE_WORLD_UI_TRANSITION_LAYER_GAME_VIEW_
                define _MODULE_WORLD_UI_TRANSITION_LAYER_GAME_VIEW_
; -----------------------------------------
; обработка перехода UI "мира"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
Layer_GameView: ; выбор перехода мира по запрошенному UI режиму
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW .NoMode                                                      ; UI_MODE_NONE
                DW Characteristics                                              ; UI_MODE_CHARACTERISTICS
                DW Inventory                                                    ; UI_MODE_INVENTORY
                DW UI.Runtime.Complete                                          ; UI_MODE_SPELLBOOK
                DW UI.Runtime.Complete                                          ; UI_MODE_MAP
                DW UI.Runtime.Complete                                          ; UI_MODE_QUEST_LOG
                DW .NoMode                                                      ; UI_MODE_GAME_MENU
                DW Options                                                      ; UI_MODE_OPTIONS
                DW .NoMode                                                      ; UI_MODE_SAVE
                DW UI.Runtime.Complete                                          ; UI_MODE_WORLD
                DW Combat                                                       ; UI_MODE_COMBAT
.NoMode         RET                                                             ; UI_MODE_NONE ни на что не влияет

                endif ; ~_MODULE_WORLD_UI_TRANSITION_LAYER_GAME_VIEW_
