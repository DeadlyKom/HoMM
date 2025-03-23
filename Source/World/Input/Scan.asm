
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
                CHECK_HARDWARE_FLAG HARDWARE_KEMPSTON_MOUSE_BIT
                JR Z, .KeyCheck                                                 ; переход, если мышь недоступна
                CALL Mouse.UpdateCursor                                         ; обновить положение курсора

                ;
                LD A, (Mouse.PositionX)
                LD L, A
                LD H, #00
                ADD HL, HL ; x2
                ADD HL, HL ; x4
                ADD HL, HL ; x8
                ADD HL, HL ; x16
                LD (Kernel.Sprite.DrawClipped.PositionX), HL

                LD A, (Mouse.PositionY)
                LD L, A
                LD H, #00
                ADD HL, HL ; x2
                ADD HL, HL ; x4
                ADD HL, HL ; x8
                ADD HL, HL ; x16
                LD (Kernel.Sprite.DrawClipped.PositionY), HL

                LD BC, Mouse.Position

                LD A, (BC)                                                      ; позиция корсора по горизонтали
                CP SCREEN_EDGE
                CALL C, Movement.Left

                LD A, (BC)
                CP SCREEN_CURSOR_X - SCREEN_EDGE
                CALL NC, Movement.Right

                INC BC

                LD A, (BC)                                                      ; позиция корсора по вертикали
                CP SCREEN_EDGE
                CALL C, Movement.Up

                LD A, (BC)
                CP SCREEN_CURSOR_Y - SCREEN_EDGE
                CALL NC, Movement.Down

.KeyCheck       ; проверка клавиш

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

                LD A, (GameState.Input.Value)
                AND MOVEMENT_MASK
                RET Z                                                           ; выход если нет онажатия клавиш

                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; установка флага обновления
                RET

                endif ; ~_WORLD_INPUT_SCAN_
