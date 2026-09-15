
                ifndef _MODULE_WORLD_UI_TRANSITION_LAYER_GAME_VIEW_
                define _MODULE_WORLD_UI_TRANSITION_LAYER_GAME_VIEW_
; -----------------------------------------
; обработка перехода UI мира
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Layer_GameView: ; выбор перехода мира по запрошенному UI режиму
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW .NoMode                                                      ; UI_MODE_NONE
                DW Characteristics                                              ; UI_MODE_CHARACTERISTICS
                DW UI.Runtime.Complete                                          ; UI_MODE_INVENTORY
                DW UI.Runtime.Complete                                          ; UI_MODE_SPELLBOOK
                DW UI.Runtime.Complete                                          ; UI_MODE_MAP
                DW UI.Runtime.Complete                                          ; UI_MODE_QUEST_LOG
                DW UI.Runtime.Complete                                          ; UI_MODE_SETTINGS
                DW Layer_GamePause                                              ; UI_MODE_GAME_PAUSE
                DW .Resume                                                      ; UI_MODE_WORLD
                DW UI.Runtime.Resume                                            ; UI_MODE_BATTLE
.NoMode         RET                                                             ; UI_MODE_NONE ни на что не влияет

.Resume         ; подготовка экрана
                SHOW_SHADOW_SCREEN                                              ; отображение теневого экрана
                CALL_IN_PAGE PAGE_7, Func.BaseScrcpy                            ; восстановление базового экрана
                HALT
                RES_RENDER_FLAG SWAP_DISABLE_BIT                                ; разрешение переключения экранов
                RES_FLAG_MODIFY World.SharedCode.Render.CursorMemcpyGate.Flag   ; разрешение работы с буфером курсора

                ; установка активного UI слоя
                SET_UI_LAYER World.SharedCode.UI.Layers.GameWorld, \
                                World.SharedCode.UI.Layers.GameWorld.Num

                RES_TICK_CONTROL_FLAG GAME_PAUSE_BIT                            ; выключить паузу игры
                JP UI.Runtime.Complete                                          ; завершить переход смены UI режима

                endif ; ~_MODULE_WORLD_UI_TRANSITION_LAYER_GAME_VIEW_
