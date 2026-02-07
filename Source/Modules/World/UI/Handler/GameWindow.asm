
                ifndef _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
                define _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
; -----------------------------------------
; обработчик UI элемента "игрового окна"
; In:
;   флаг переполнения Carrry сброшен, если  таймера подсказки обнулился
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWindow:     ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                RET NZ                                                          ; выход, если не нажата клавиша "выбор"
                JR$
                RET

                endif ; ~_MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
