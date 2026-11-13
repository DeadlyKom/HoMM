
                ifndef _MODULE_WORLD_INPUT_MENU_PAUSE_
                define _MODULE_WORLD_INPUT_MENU_PAUSE_
; -----------------------------------------
; открыть меню "опций" по первому нажатию клавиши меню
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   - обработчик вызывается многократно как при нажатой,
;     так и при отпущенной клавише
;   - защёлка исключает повторное переключение при удержании
; -----------------------------------------
Input.MenuPause:; проверка клавиши "меню/пауза"
                LD A, (GameConfig.KeyMenu)
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша отпущена

                ; проверка флага обработки первого нажатия
.Flag           FLAG_MODIFY 0                                                   ; флаг, текущее нажатие клавиши уже обработано
                RET C                                                           ; выход, если обработанная клавиша продолжает удерживаться

                SET_FLAG_MODIFY Input.MenuPause.Flag                            ; установка флага защёлки обработки первого нажатия

                ; запрос открытия меню "опций"
                LD A, UI_MODE_OPTIONS
                JP UI.Runtime.Request                                           ; запрос смены UI режима

.Released       RES_FLAG_MODIFY Input.MenuPause.Flag                            ; сброс флага защёлки после отпускания клавиши
                RET

                endif ; ~_MODULE_WORLD_INPUT_MENU_PAUSE_
