
                ifndef _MODULE_WORLD_UI_INITIALIZE_PREVIOUS_MODE_
                define _MODULE_WORLD_UI_INITIALIZE_PREVIOUS_MODE_
; -----------------------------------------
; инициализация запроса предыдущего UI режима
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
PreviousMode:   ; чтение предыдущего UI режима
                LD A, (GameState.UIRuntime + FUIRuntime.PreviousMode)
                JP UI.Runtime.Request                                           ; запрос смены UI режима

                endif ; ~_MODULE_WORLD_UI_INITIALIZE_PREVIOUS_MODE_
