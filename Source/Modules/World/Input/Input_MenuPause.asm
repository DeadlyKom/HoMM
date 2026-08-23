
                ifndef _MODULE_WORLD_INPUT_MENU_PAUSE_
                define _MODULE_WORLD_INPUT_MENU_PAUSE_
; -----------------------------------------
; переключить паузу мира по первому нажатию клавиши меню
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   обработчик вызывается каждое прерывание как при нажатой,
;   так и при отпущенной клавише;
;   защёлка исключает повторное переключение при удержании
; -----------------------------------------
Input.MenuPause:; проверка клавиши "меню/пауза"
                LD A, (GameConfig.KeyMenu)
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша отпущена

.Flag           FLAG_MODIFY 0                                                   ; флаг, текущее нажатие клавиши уже обработано
                RET C                                                           ; выход, если обработанная клавиша продолжает удерживаться

                SET_FLAG_MODIFY Input.MenuPause.Flag                            ; установка флага защёлки обработки первого нажатия

                ; проверка текущего состояния паузы мира
                LD HL, GameState.UIRuntime + FUIRuntime.Flags
                BIT UI_GAME_PAUSE_BIT, (HL)
                JR Z, .Pause                                                    ; переход, если флаг паузы сброшен

                RES UI_GAME_PAUSE_BIT, (HL)                                     ; сброс флага, продолжить симуляцию мира
                RET

.Pause          SET UI_GAME_PAUSE_BIT, (HL)                                     ; установка флага, остановить симуляцию мира
                RET

.Released       RES_FLAG_MODIFY Input.MenuPause.Flag                            ; сброс флага защёлки после отпускания клавиши
                RET

                endif ; ~_MODULE_WORLD_INPUT_MENU_PAUSE_
