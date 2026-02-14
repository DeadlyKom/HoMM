
                ifndef _MODULE_WORLD_INPUT_ACCELERATE_
                define _MODULE_WORLD_INPUT_ACCELERATE_
; -----------------------------------------
; событие ввода - 'ускорение'
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Input.Accelerate; установка флага, ускореное перемещение
                LD HL, GameState.Input.Value
                SET ACCELERATE_CURSOR_BIT, (HL)
                RET

                endif ; ~_MODULE_WORLD_INPUT_ACCELERATE_
