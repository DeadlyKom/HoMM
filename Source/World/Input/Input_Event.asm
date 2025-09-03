
                ifndef _WORLD_INPUT_EVENT_
                define _WORLD_INPUT_EVENT_
; -----------------------------------------
; событие ввода - 'выбор'
; In:
;   флаг нуля, сброшен если ввод не активен
; Out:
; Corrupt:
; Note:
; -----------------------------------------
IputEvent.Select; установка флага, нажатия клавиши "выбор"
                LD HL, GameState.Input.Value
                SET SELECT_KEY_BIT, (HL)
                
                ; проверка отсутствия событий ввода
                LD BC, GameState.Event
                LD A, (BC)
                CP EVENT_NONE
                RET NZ                                                          ; выход, если имеется какое то событие

                ; ToDo: в зависимости от режима выбора, меняется поведение расчёта координат

.RequestPath    ; --------------------------------------------------------------
                ; формирование события - поиск пути
                ; FEvent.Type
                LD A, EVENT_PATHFINDING
                LD (BC), A
                INC C

                ; FEvent.HeroID
                LD A, #00
                LD (BC), A
                INC C

                ; расчёт положение точки назначения в тайлах и уставновка как входные данные для события - поиск пути
                LD HL, GameSession.WorldInfo + FWorldInfo.MapPosition

                ; FEvent.Position.X
                LD A, (Mouse.PositionX)
                RRA
                RRA
                RRA
                DEC A                                                           ; SUB SCR_WORLD_POS_X
                ADD A, (HL)
                RRA
                AND %00001111
                INC L
                LD (BC), A   
                INC C
                                             
                ; FEvent.Position.Y
                LD A, (Mouse.PositionY)
                RRA
                RRA
                RRA
                DEC A                                                           ; SUB SCR_WORLD_POS_Y
                ADD A, (HL)
                RRA
                AND %00001111
                LD (BC), A                                                    

                RET
; -----------------------------------------
; событие ввода - 'ускорение'
; In:
;   флаг нуля, сброшен если ввод не активен
; Out:
; Corrupt:
; Note:
; -----------------------------------------
IputEvent.Accelerate; установка флага, ускореное перемещение
                LD HL, GameState.Input.Value
                SET ACCELERATE_CURSOR_BIT, (HL)

                RET

                endif ; ~_WORLD_INPUT_EVENT_
