
                ifndef _MODULE_WORLD_UI_INITIALIZE_LAYER_GAME_PAUSE_
                define _MODULE_WORLD_UI_INITIALIZE_LAYER_GAME_PAUSE_
; -----------------------------------------
; инициализация запроса UI слоя "меню паузы"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Layer_GamePause:; инициализация
                LD A, UI_MODE_GAME_PAUSE
                JP UI.Runtime.Request                                           ; запрос смены UI режима

                endif ; ~_MODULE_WORLD_UI_INITIALIZE_LAYER_GAME_PAUSE_
