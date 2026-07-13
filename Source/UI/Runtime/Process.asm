
                ifndef _UI_RUNTIME_PROCESS_
                define _UI_RUNTIME_PROCESS_
; -----------------------------------------
; обработка запроса смены UI режима
; In:
; Out:
;   флаг переполнения Carry сброшен, сигнализируя неудачность операции
; Corrupt:
; Note:
; -----------------------------------------
Process:        ; инициализация
                LD HL, GameState.UIRuntime + FUIRuntime.Flags
                OR A                                                            ; сброс фалага

                ; проверка наличия запроса смены UI режима
                BIT UI_REQUEST_PENDING_BIT, (HL)
                RET Z                                                           ; выход, т.к. запрос отсутствует

                ; проверка активной фазы перехода UI режима
                BIT UI_TRANSITION_ACTIVE_BIT, (HL)
                RET NZ                                                          ; выход, т.е. идёт фаза перехода UI режима

                ifdef _DEBUG
                ; защита от служебного или повреждённого значения режима
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                OR A                                                            ; UI_MODE_NONE
                JR Z, .CancelRequest
                CP UI_MODE_MAX
                JR NC, .CancelRequest
                endif

                ; смена флагов, позволяющая активировать фазу перехода UI режима
                RES UI_REQUEST_PENDING_BIT, (HL)
                SET UI_TRANSITION_ACTIVE_BIT, (HL)

                ; заблокировать "мир" и запустить нужный переход
                SET_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; блокировать сканирывания ввода
                SET_UI_FLAG UI_GAME_PAUSE_BIT                                   ; включение паузы игры

                SCF                                                             ; флаг установлен, операция успешна
                RET

.CancelRequest  RES UI_REQUEST_PENDING_BIT, (HL)                                ; удалить недопустимый запрос
                OR A                                                            ; флаг Carry сброшен, UI режим не изменяется
                RET

                endif ; ~_UI_RUNTIME_PROCESS_
