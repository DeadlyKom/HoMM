
                ifndef _MODULE_WORLD_INPUT_ACCELERATE_
                define _MODULE_WORLD_INPUT_ACCELERATE_
; -----------------------------------------
; событие ввода - 'ускорение'
; In:
;   флаг нуля, сброшен если ввод не активен
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Iput.Accelerate ; установка флага, ускореное перемещение
                LD HL, GameState.Input.Value
                SET ACCELERATE_CURSOR_BIT, (HL)
                RET

                endif ; ~_MODULE_WORLD_INPUT_ACCELERATE_
