
                ifndef _UI_RUNTIME_REQUEST_
                define _UI_RUNTIME_REQUEST_
; -----------------------------------------
; запрос смены UI режима
; In:
;   A - новый режим
; Out:
;   флаг переполнения сброшен, сигнализируя неудачность операции
; Corrupt:
; Note:
; -----------------------------------------
Request:        ; инициализация
                LD HL, GameState.UIRuntime + FUIRuntime.Flags
                OR A                                                            ; сброс флага и проверка на UI_MODE_NONE
                RET Z                                                           ; выход, если UI_MODE_NONE 
                                                                                ; является служебным значением и не может быть запрошен

                LD C, A

                ; проверка наличия UI режима
                CP UI_MODE_MAX
                RET NC                                                          ; выход, такой режим UI отсутствует
                
                ; проверка отличия нового режима с текущем
                LD A, (GameState.UIRuntime + FUIRuntime.Mode)
                CP C
                RET Z                                                           ; выход, если режим не отличается
                                                                                ; флаг переполнения будет сброшен, неудачная операция

                OR A                                                            ; сброс флага
                ; проверка отсутствия запроса смены UI режима
                BIT UI_REQUEST_PENDING_BIT, (HL)
                RET NZ                                                          ; выход, т.к. запрос уже/ещё активен

                ; проверка активной фазы перехода UI режима
                BIT UI_TRANSITION_ACTIVE_BIT, (HL)
                RET NZ                                                          ; выход, т.е. идёт фаза перехода UI режима

                ; сохранение запрашивамого режима UI
                LD A, C
                LD (GameState.UIRuntime + FUIRuntime.RequestedMode), A

                ; установка флага запроса смены режима UI
                LD HL, GameState.UIRuntime + FUIRuntime.Flags
                SET UI_REQUEST_PENDING_BIT, (HL)

                SCF                                                             ; флаг установлен, операция успешна
                RET

                endif ; ~_UI_RUNTIME_REQUEST_
