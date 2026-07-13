
                ifndef _UI_RUNTIME_COMPLETE_
                define _UI_RUNTIME_COMPLETE_
; -----------------------------------------
; завершить перехода запроса смены UI режима
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Complete:       ; сохранение предыдущего режима
                LD A, (GameState.UIRuntime + FUIRuntime.Mode)
                LD (GameState.UIRuntime + FUIRuntime.PreviousMode), A

                ; установка требуемого режима
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD (GameState.UIRuntime + FUIRuntime.Mode), A

                ; CALL ActivateLayerForMode

                ; сброс флага переходного состояния UI режима
                LD HL, GameState.UIRuntime + FUIRuntime.Flags
                RES UI_TRANSITION_ACTIVE_BIT, (HL)

                RET

.Resume         ; восстановить работу
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_UI_FLAG UI_GAME_PAUSE_BIT                                   ; выключение паузы игры                              
                JR Complete

                endif ; ~_UI_RUNTIME_COMPLETE_
