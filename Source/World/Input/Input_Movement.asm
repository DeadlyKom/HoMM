
                ifndef _WORLD_INPUT_MOVEMENT_
                define _WORLD_INPUT_MOVEMENT_
; -----------------------------------------
; перемещение влево
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Left   LD HL, GameState.Input.Value
                SET MOVEMENT_LEFT_BIT, (HL)
                RET
; -----------------------------------------
; перемещение вправо
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Right  LD HL, GameState.Input.Value
                SET MOVEMENT_RIGHT_BIT, (HL)
                RET
; -----------------------------------------
; перемещение вверх
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Up     LD HL, GameState.Input.Value
                SET MOVEMENT_UP_BIT, (HL)
                RET
; -----------------------------------------
; перемещение вниз
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Down   LD HL, GameState.Input.Value
                SET MOVEMENT_DOWN_BIT, (HL)
                RET

                endif ; ~_WORLD_INPUT_MOVEMENT_
