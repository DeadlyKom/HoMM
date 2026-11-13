
                ifndef _MODULE_INVENTORY_INPUT_SELECT_
                define _MODULE_INVENTORY_INPUT_SELECT_
; -----------------------------------------
; событие ввода - "выбор"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
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

                ; проверка запроса или выполнения перехода UI
                CHECK_UI_FLAGS UI_REQUEST_PENDING | UI_TRANSITION_ACTIVE
                RET NZ                                                          ; выход, если переход UI запрошен или уже выполняется

                ; проверка уже взятого предмета
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                JR NZ, .Place                                                   ; переход, если предмет уже взят для перетаскивания

                ; сохранение позиции курсора для определения предмета в основном цикле
                LD HL, (Mouse.Position)
                LD (Inventory.States.DraggedItem.GrabOffset), HL

                ; запрос взятия предмета в основном цикле
                SET_INPUT_FLAG INPUT_DRAG_DROP_BIT
                SET_FLAG_MODIFY Inventory.DragAndDrop.TakeItem.Request
                RET

.Place          ; сохранение позиции курсора для размещения предмета
                LD HL, (Mouse.Position)
                LD (Inventory.DragAndDrop.Cursor), HL

                ; запрос размещения предмета в основном цикле
                SET_FLAG_MODIFY Inventory.DragAndDrop.PutItem.Request
                RET

                endif ; ~_MODULE_INVENTORY_INPUT_SELECT_
