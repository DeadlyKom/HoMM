
                ifndef _MODULE_INVENTORY_INPUT_ACCELERATE_
                define _MODULE_INVENTORY_INPUT_ACCELERATE_
; -----------------------------------------
; обработка клавиши "ускорение" для показа всех слотов
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Input.Accelerate; проверка состояния клавиши "ускорение"
                LD A, (GameConfig.KeyAccel)
                CALL Input.CheckKeyState
                LD HL, GameState.Input.Value
                JR Z, .Pressed                                                  ; переход, если клавиша нажата

                ; сброс состояния клавиши при отпускании
                RES ACCELERATE_CURSOR_BIT, (HL)
                RET

.Pressed        ; проверка сохранённого состояния клавиши
                BIT ACCELERATE_CURSOR_BIT, (HL)
                RET NZ                                                          ; выход, если нажатие уже обработано

                SET ACCELERATE_CURSOR_BIT, (HL)                                 ; фиксация нового нажатия клавиши

                ; запрос перерисовки окна перед сохранением фонов слотов
                LD HL, Inventory.States.HoveredItem.Flags
                SET_FLAG INVENTORY_REDRAW_BIT
                RET

                endif ; ~_MODULE_INVENTORY_INPUT_ACCELERATE_
