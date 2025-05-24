
                ifndef _WORLD_INPUT_EVENT_HANDLER_
                define _WORLD_INPUT_EVENT_HANDLER_
; -----------------------------------------
; обработчик событий ввода
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Handler         ; обработка события
                LD HL, GameState.Input.Event
                LD A, (HL)
                LD (HL), KEY_ID_NONE                                            ; сброс события ввода

                ; проверка наличия события
                CP KEY_ID_NONE
                RET Z                                                           ; выход, если событие отсутствует

                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW #0000                                                        ; KEY_ID_MENU
                DW #0000                                                        ; KEY_ID_ACCELERATION
                DW #0000                                                        ; KEY_ID_ESC
                DW Handler.Select                                               ; KEY_ID_SELECT
                DW #0000                                                        ; KEY_ID_RIGHT
                DW #0000                                                        ; KEY_ID_LEFT
                DW #0000                                                        ; KEY_ID_DOWN
                DW #0000                                                        ; KEY_ID_UP

                endif ; ~_WORLD_INPUT_EVENT_HANDLER_
