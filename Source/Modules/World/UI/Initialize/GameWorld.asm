
                ifndef _MODULE_WORLD_UI_INITIALIZE_GAME_WORLD_
                define _MODULE_WORLD_UI_INITIALIZE_GAME_WORLD_
; -----------------------------------------
; инициализация запроса игрового режима "мир"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWorld:      ; инициализация
                LD A, UI_MODE_WORLD
                JP UI.Runtime.Request                                           ; запрос смены UI режима

                endif ; ~_MODULE_WORLD_UI_INITIALIZE_GAME_WORLD_
