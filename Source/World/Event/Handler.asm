
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

                ; ловушка
                ifdef _DEBUG
                CP EVENT_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого события
                endif

                ; проверка наличия события
                CP EVENT_NONE
                RET Z                                                           ; выход, если событие отсутствует

                DEC A                                                           ; пропуск нулевого
                LD HL, .JumpTable
                CALL Func.JumpTable

                ; сброс события
                LD HL, GameState.Event
                LD (HL), EVENT_NONE
.RET            RET

.JumpTable      DW .RET ; Pathfinding                                                  ; EVENT_PATHFINDING

                endif ; ~_WORLD_EVENT_HANDLER_
