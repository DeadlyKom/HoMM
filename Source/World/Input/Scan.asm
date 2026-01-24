
                ifndef _WORLD_INPUT_SCAN_
                define _WORLD_INPUT_SCAN_
; -----------------------------------------
; сканирование устроиств ввода
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Scan:           ; проверка HardWare ограничения мыши
                CHECK_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_MOUSE_BIT
                JR Z, .KeyCheck                                                 ; переход, если мышь недоступна
                CALL Mouse.UpdateCursor                                         ; обновить положение курсора

                LD BC, Mouse.Position

                LD A, (BC)                                                      ; позиция корсора по горизонтали
                CP SCREEN_EDGE
                CALL C, Movement.Left.Force

                LD A, (BC)
                CP SCREEN_CURSOR_X - SCREEN_EDGE
                CALL NC, Movement.Right.Force

                INC BC

                LD A, (BC)                                                      ; позиция корсора по вертикали
                CP SCREEN_EDGE
                CALL C, Movement.Up.Force

                LD A, (BC)
                CP SCREEN_CURSOR_Y - SCREEN_EDGE
                CALL NC, Movement.Down.Force

.KeyCheck       ; --------------------------------------------------------------
                ; очистка системных клавиш
                LD A, (GameState.Input.Value)
                AND ~KEY_MASK
                LD (GameState.Input.Value), A
                ; --------------------------------------------------------------
                ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                CALL Z, IputEvent.Select                                        ; переход, если клавиша нажата

                ; проверка клавиши "выход"
                ; LD A, (GameConfig.KeyESC)

                ; проверка клавиши "меню/пауза"
                ; LD A, (GameConfig.KeyMenu)

                ; проверка клавиш перемещения
                LD A, (GameConfig.KeyAccel)
                CALL Input.CheckKeyState
                CALL Z, IputEvent.Accelerate
                ; --------------------------------------------------------------
                ; опрос перемещения влево
                LD A, (GameConfig.KeyLeft)
                CALL Input.CheckKeyState
                CALL Z, Movement.Left

                ; опрос перемещения вправо
                LD A, (GameConfig.KeyRight)
                CALL Input.CheckKeyState
                CALL Z, Movement.Right

                ; опрос перемещения вверх
                LD A, (GameConfig.KeyUp)
                CALL Input.CheckKeyState
                CALL Z, Movement.Up

                ; опрос перемещения вниз
                LD A, (GameConfig.KeyDown)
                CALL Input.CheckKeyState
                CALL Z, Movement.Down
                ; --------------------------------------------------------------
                ; проверка нажатий клавиш перемещения
                LD A, (GameState.Input.Value)
                AND MOVEMENT_MASK
                RET Z                                                           ; выход если нет онажатия клавиш

                SET_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; установка флага разрешения обновления скрола карты
                RET

                endif ; ~_WORLD_INPUT_SCAN_
