
                ifndef _MODULE_WORLD_UI_INITIALIZE_GAME_PAUSE_
                define _MODULE_WORLD_UI_INITIALIZE_GAME_PAUSE_
; -----------------------------------------
; инициализация запроса игрового меню паузы
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GamePause:      ; инициализация
                LD A, UI_MODE_GAME_PAUSE
                JP UI.Runtime.Request                                           ; запрос смены UI режима

                endif ; ~_MODULE_WORLD_UI_INITIALIZE_GAME_PAUSE_
