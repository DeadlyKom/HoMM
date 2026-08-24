
                ifndef _MODULE_WORLD_UI_TRANSITION_GAME_WORLD_
                define _MODULE_WORLD_UI_TRANSITION_GAME_WORLD_
; -----------------------------------------
; переход к игровому слою
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWorld:      ; подготовка экрана
                SHOW_SHADOW_SCREEN                                              ; отображение теневого экрана
                CALL_IN_PAGE PAGE_7, Func.BaseScrcpy                            ; восстановление базового экрана
                HALT
                RES_RENDER_FLAG SWAP_DISABLE_BIT                                ; разрешение переключения экранов
                RES_FLAG_MODIFY World.Base.Render.CursorMemcpyGate.Flag         ; разрешение работы с буфером курсора

                ; установка активного UI слоя
                SET_UI_LAYER World.Base.Layers.GameWorld, \
                                World.Base.Layers.GameWorld.Num

                RES_TICK_CONTROL_FLAG GAME_PAUSE_BIT                            ; выключить паузу игры
                JP UI.Runtime.Complete                                          ; завершить переход смены UI режима

                endif ; ~_MODULE_WORLD_UI_TRANSITION_GAME_WORLD_
