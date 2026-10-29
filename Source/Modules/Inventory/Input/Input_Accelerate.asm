
                ifndef _MODULE_INVENTORY_INPUT_ACCELERATE_
                define _MODULE_INVENTORY_INPUT_ACCELERATE_
; -----------------------------------------
; событие ввода - "ускорение"
; In:
; Out:
; Corrupt:
;   HL
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Input.Accelerate; фиксация удержания клавиши показа всех слотов
                LD HL, GameState.Input.Value
                SET ACCELERATE_CURSOR_BIT, (HL)
                RET

                endif ; ~_MODULE_INVENTORY_INPUT_ACCELERATE_
