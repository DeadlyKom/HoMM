
                ifndef _MODULE_WORLD_INPUT_SELECT_
                define _MODULE_WORLD_INPUT_SELECT_
; -----------------------------------------
; событие ввода - 'выбор'
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Input.Select    ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша отпущена
                
                ; установка флага, нажатие "выбор"
                LD HL, GameState.Input.Value
                SET SELECT_KEY_BIT, (HL)
                RET

.Released       ; сброс флага защёлок
                RES_FLAG_MODIFY World.UI.Handler.Center.Flag                    ; сброс защёлок обработанного нажатия клавиши "выбор"
                RET

                endif ; ~_MODULE_WORLD_INPUT_SELECT_
