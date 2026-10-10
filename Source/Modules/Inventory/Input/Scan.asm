
                ifndef _MODULE_INVENTORY_INPUT_SCAN_
                define _MODULE_INVENTORY_INPUT_SCAN_
; -----------------------------------------
; обработка ввода экрана инвентаря
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Scan:           ; проверка доступности мыши
                CHECK_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_MOUSE_BIT
                JR Z, .KeyCheck                                                 ; переход, если мышь недоступна
                CALL Mouse.UpdateCursor                                         ; обновить положение курсора

.KeyCheck       ; --------------------------------------------------------------
                ; очистка системных клавиш
                LD A, (GameState.Input.Value)
                AND ~KEY_MASK
                LD (GameState.Input.Value), A
                ; --------------------------------------------------------------

                ; проверка клавиши "выход"
                LD A, (GameConfig.KeyESC)
                CALL Input.CheckKeyState
                CALL Z, Input.Exit                                              ; вызов обработчика выхода, если клавиша нажата

                ; проверка клавиши "переход к предыдущему"
                LD A, (GameConfig.KeyPrevious)
                CALL Input.CheckKeyState
                CALL Z, Input.Previous                                          ; вызов обработчика "переход к предыдущему", если клавиша нажата

                ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                CALL Z, Input.Select                                            ; вызов обработчика выбора, если клавиша нажата

                RET

                endif ; ~_MODULE_INVENTORY_INPUT_SCAN_
