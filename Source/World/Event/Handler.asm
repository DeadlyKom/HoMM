
                ifndef _WORLD_EVENT_HANDLER_
                define _WORLD_EVENT_HANDLER_
; -----------------------------------------
; обработчик событий
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Handler         ; обработка события
                LD HL, GameState.Event
                LD A, (HL)

                ; проверка наличия события
                CP EVENT_NONE
                RET Z                                                           ; выход, если событие отсутствует

                LD (HL), EVENT_NONE                                             ; сброс события ввода
                DEC A                                                           ; пропуск нулевого
                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW Pathfinding                                                  ; EVENT_PATHFINDING

                endif ; ~_WORLD_EVENT_HANDLER_
