
                ifndef _MODULE_WORLD_UI_INITIALIZE_LAYER_GAME_VIEW_
                define _MODULE_WORLD_UI_INITIALIZE_LAYER_GAME_VIEW_
; -----------------------------------------
; инициализация запроса UI слоя "игрового окна"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Layer_GameView: ; инициализация
                LD A, UI_MODE_WORLD
                JP UI.Runtime.Request                                           ; запрос смены UI режима

                endif ; ~_MODULE_WORLD_UI_INITIALIZE_LAYER_GAME_VIEW_
