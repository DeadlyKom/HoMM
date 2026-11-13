
                ifndef _MODULE_WORLD_INPUT_BATTLE_
                define _MODULE_WORLD_INPUT_BATTLE_
; -----------------------------------------
; запуск битвы по первому нажатию B (отладочная)
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; -----------------------------------------
Input.Battle:   ; проверка клавиши запуска битвы
                LD A, VK_B
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша B отпущена

                ; проверка обработки текущего нажатия
.Flag           FLAG_MODIFY 0                                                   ; флаг, текущее нажатие B уже обработано
                RET C                                                           ; выход, если клавиша B продолжает удерживаться

                SET_FLAG_MODIFY Input.Battle.Flag                                ; установка защёлки текущего нажатия

                ; запрос перехода из мира в битву
                LD A, UI_MODE_BATTLE
                JP UI.Runtime.Request

.Released       RES_FLAG_MODIFY Input.Battle.Flag                                ; сброс защёлки после отпускания B
                RET

                endif ; ~_MODULE_WORLD_INPUT_BATTLE_
