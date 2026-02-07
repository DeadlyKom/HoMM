
                ifndef _MODULE_WORLD_INPUT_MOVEMENT_
                define _MODULE_WORLD_INPUT_MOVEMENT_
; -----------------------------------------
; перемещение влево
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Left   ; проверка достижения левого края карты
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                LD C, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)          ; тупое объединение подходит для проверки на 0
                OR C
                JP Z, Cursor.MoveLeft                                           ; переход, т.к. достигли левого края карты, доступно только перемещение курсора

                ; проверка нажатия клавиши ускорения
                LD HL, GameState.Input.Value
                BIT ACCELERATE_CURSOR_BIT, (HL)
                RES MOVEMENT_RIGHT_BIT, (HL)
                JR NZ, .Force                                                   ; переход, нажата клавиша ускорения
                CALL Cursor.MoveLeft

                ; проверка достижения левого края
                LD A, (Mouse.PositionX)
                CP SCREEN_EDGE
                RET NC                                                          ; выход, если достигли левого края карты

.Force          ; принудительное смещение карты влево
                LD HL, GameState.Input.Value
                SET MOVEMENT_LEFT_BIT, (HL)
                RET
; -----------------------------------------
; перемещение вправо
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Right  ; проверка достижения правого края карты
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                ; ToDo: добавить учёт смещение гексагона GameSession.WorldInfo + FWorldInfo.MapOffset.X
                CP (64 - SCR_WORLD_SIZE_X) * 2 + 2 - 1
                JP Z, Cursor.MoveRight                                          ; переход, т.к. достигли правого края карты, доступно только перемещение курсора

                ; проверка нажатия клавиши ускорения
                LD HL, GameState.Input.Value
                BIT ACCELERATE_CURSOR_BIT, (HL)
                RES MOVEMENT_LEFT_BIT, (HL)
                JR NZ, .Force                                                   ; переход, нажата клавиша ускорения
                CALL Cursor.MoveRight

                ; проверка достижения правого края
                LD A, (Mouse.PositionX)
                CP SCREEN_CURSOR_X - SCREEN_EDGE
                RET C                                                           ; выход, если достигли правого края карты

.Force          ; принудительное смещение карты вправо
                LD HL, GameState.Input.Value
                SET MOVEMENT_RIGHT_BIT, (HL)
                RET
; -----------------------------------------
; перемещение вверх
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Up     ; проверка достижения вверхнего края карты
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                LD C, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)          ; тупое объединение подходит для проверки на 0
                OR C
                JP Z, Cursor.MoveUp                                             ; переход, т.к. достигли вверхнего края карты, доступно только перемещение курсора

                ; проверка нажатия клавиши ускорения
                LD HL, GameState.Input.Value
                BIT ACCELERATE_CURSOR_BIT, (HL)
                RES MOVEMENT_DOWN_BIT, (HL)
                JR NZ, .Force                                                   ; переход, нажата клавиша ускорения
                CALL Cursor.MoveUp

                ; проверка достижения верхнего края
                LD A, (Mouse.PositionY)
                CP SCREEN_EDGE
                RET NC                                                          ; выход, если достигли верхнего края карты

.Force          ; принудительное смещение карты вверх
                LD HL, GameState.Input.Value
                SET MOVEMENT_UP_BIT, (HL)
                RET
; -----------------------------------------
; перемещение вниз
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Movement.Down   ; проверка достижения нижнего края карты
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                ; ToDo: добавить учёт смещение гексагона GameSession.WorldInfo + FWorldInfo.MapOffset.Y
                CP (64 - SCR_WORLD_SIZE_Y) * 2 + 1 - 1
                JP Z, Cursor.MoveDown                                           ; переход, т.к. достигли нижнего края карты, доступно только перемещение курсора
                
                ; проверка нажатия клавиши ускорения
                LD HL, GameState.Input.Value
                BIT ACCELERATE_CURSOR_BIT, (HL)
                RES MOVEMENT_UP_BIT, (HL)
                JR NZ, .Force                                                   ; переход, нажата клавиша ускорения
                CALL Cursor.MoveDown

                ; проверка достижения нижнего края
                LD A, (Mouse.PositionY)
                CP SCREEN_CURSOR_Y - SCREEN_EDGE
                RET C                                                           ; выход, если достигли нижнего края карты

.Force          ; принудительное смещение карты вниз
                LD HL, GameState.Input.Value
                SET MOVEMENT_DOWN_BIT, (HL)
                RET

                endif ; ~_MODULE_WORLD_INPUT_MOVEMENT_
