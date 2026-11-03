
                ifndef _MODULE_INVENTORY_INPUT_SELECT_
                define _MODULE_INVENTORY_INPUT_SELECT_
; -----------------------------------------
; событие ввода - 'выбор'
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Input.Select    ; проверка состояния клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                JR Z, .Pressed                                                  ; переход, если клавиша нажата

                ; разрешение следующего нажатия после отпускания клавиши
                RES_FLAG_MODIFY .PressGate
                RET

.Pressed        ; сохранение состояния удержания для анимации курсора
                LD HL, GameState.Input.Value
                SET SELECT_KEY_BIT, (HL)

                ; проверка обработки текущего нажатия
.PressGate      FLAG_MODIFY 0                                                   ; флаг, текущее нажатие уже обработано
                RET C                                                           ; выход, если текущее нажатие уже обработано

                ; блокировка повторной обработки до отпускания клавиши
                SET_FLAG_MODIFY .PressGate
                RET

                endif ; ~_MODULE_INVENTORY_INPUT_SELECT_
