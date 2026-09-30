
                ifndef _MODULE_CHARACTERISTICS_INPUT_SCAN_
                define _MODULE_CHARACTERISTICS_INPUT_SCAN_
; -----------------------------------------
; обработка ввода экрана характеристик
; In:
; Out:
; Corrupt:
; Note:
;   пустышка, обработка ввода пока отсутствует
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

                ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                CALL Z, Input.Select                                            ; переход, если клавиша нажата

                RET

                endif ; ~_MODULE_CHARACTERISTICS_INPUT_SCAN_
