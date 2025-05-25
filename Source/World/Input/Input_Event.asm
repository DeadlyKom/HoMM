
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
                LD HL, GameState.Event
                LD A, (HL)
                CP EVENT_NONE
                RET NZ

                ; формирование события нажатия выбор
                LD (HL), EVENT_PATHFINDING                                      ; FEvent.Type
                INC L
                LD (HL), #00                                                    ; FEvent.HeroID
                INC L
                LD (HL), #00                                                    ; FEvent.Position.X
                INC L
                LD (HL), #00                                                    ; FEvent.Position.Y

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
