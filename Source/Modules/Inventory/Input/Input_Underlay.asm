
                ifndef _MODULE_INVENTORY_INPUT_UNDERLAY_
                define _MODULE_INVENTORY_INPUT_UNDERLAY_
; -----------------------------------------
; переключение типа подложки описания отладочной клавишей T
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   одно переключение на нажатие, повторное разрешается после отпускания
; -----------------------------------------
Input.Underlay  ; проверка состояния отладочной клавиши T
                LD A, VK_T
                CALL Input.CheckKeyState
                JR Z, .Pressed                                                  ; переход, если клавиша нажата

                ; сброс фиксации нажатия после отпускания клавиши
                RES_FLAG_MODIFY .Held
                RET

.Pressed        ; проверка сохранённого состояния клавиши
.Held           FLAG_MODIFY 0
                RET C                                                           ; выход, если нажатие уже обработано

                SET_FLAG_MODIFY .Held                                           ; фиксация нового нажатия клавиши

                ; переключение типа подложки описания
                LD A, (GameConfig.Options)
                XOR O_DESC_OPAQUE
                LD (GameConfig.Options), A

                ; запрос перерисовки окна с новым типом подложки
                LD HL, Inventory.States.HoveredItem.Flags
                SET_FLAG INVENTORY_REDRAW_BIT
                RET

                endif ; ~_MODULE_INVENTORY_INPUT_UNDERLAY_
