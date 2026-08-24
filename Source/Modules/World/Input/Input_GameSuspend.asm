
                ifndef _MODULE_WORLD_INPUT_GAME_SUSPEND_
                define _MODULE_WORLD_INPUT_GAME_SUSPEND_
; -----------------------------------------
; переключить запрос режима "остановки времени"
; по первому нажатию клавиши режима "остановки времени"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   изменяется запрошенное состояние; фактический GAME_SUSPEND_BIT
;   применяется планировщиком тиков только на границе cadence-эпохи
; -----------------------------------------
Input.GameSuspend:
                ; проверка клавиши режима "остановки времени"
                LD A, (GameConfig.KeySuspend)
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша отпущена

                ; проверка флага обработки первого нажатия
.Flag           FLAG_MODIFY 0                                                   ; флаг, текущее нажатие клавиши уже обработано
                RET C                                                           ; выход, если обработанная клавиша продолжает удерживаться

                SET_FLAG_MODIFY Input.GameSuspend.Flag                          ; установка флага защёлки обработки первого нажатия
                SWAP_TICK_REQUEST_FLAG GAME_SUSPEND_REQUEST_BIT                 ; смена запрошенного состояния режима "остановки времени"
                RET

.Released       RES_FLAG_MODIFY Input.GameSuspend.Flag                          ; сбросить защёлку после отпускания клавиши
                RET

                endif ; ~_MODULE_WORLD_INPUT_GAME_SUSPEND_
