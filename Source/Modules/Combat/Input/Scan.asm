
                ifndef _MODULE_COMBAT_INPUT_SCAN_
                define _MODULE_COMBAT_INPUT_SCAN_
; -----------------------------------------
; обработка ввода экрана "сражения"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "сражения"
;   доступны движение курсора и выход, боевые действия пока отсутствуют
; -----------------------------------------
Scan:           ; проверка HardWare ограничения мыши
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

                ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                CALL Z, Input.Select                                            ; вызов, если клавиша нажата

                RET

                endif ; ~_MODULE_COMBAT_INPUT_SCAN_
