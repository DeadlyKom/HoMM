
                ifndef _MODULE_INVENTORY_INPUT_SELECT_
                define _MODULE_INVENTORY_INPUT_SELECT_
; -----------------------------------------
; событие ввода - 'выбор'
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Input.Select    ; фиксация нажатия клавиши "выбор"
                LD HL, GameState.Input.Value
                SET SELECT_KEY_BIT, (HL)
                RET

                endif ; ~_MODULE_INVENTORY_INPUT_SELECT_
