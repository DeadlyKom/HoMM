
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
IputEvent.Select; проверка отсутствия событий ввода
                LD HL, GameState.Input.Event
                LD A, (HL)
                CP KEY_ID_NONE
                RET NZ

                ; формирование события нажатия выбор
                LD (HL), KEY_ID_SELECT
                INC L
                LD (HL), #00
                INC L
                LD (HL), #00

                RET

                endif ; ~_WORLD_INPUT_EVENT_
