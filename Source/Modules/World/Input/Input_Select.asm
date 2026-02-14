
                ifndef _MODULE_WORLD_INPUT_SELECT_
                define _MODULE_WORLD_INPUT_SELECT_
; -----------------------------------------
; событие ввода - 'выбор'
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Input.Select    ; установка флага, нажатие "выбор"
                LD HL, GameState.Input.Value
                SET SELECT_KEY_BIT, (HL)
                RET

                endif ; ~_MODULE_WORLD_INPUT_SELECT_
