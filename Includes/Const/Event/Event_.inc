
                ifndef _CONST_EVENT_
                define _CONST_EVENT_
EVENT_SIZE                          EQU 16                                      ; размер структуры объекта FEvent
EVENT_MAX                           EQU 16                                      ; максимальное количество событий
EVENT_EMPTY_ELEMENT                 EQU #FF                                     ; свободный элемент массива (значение заполнения массива)

; флаги FEvent.Flags 
EVENT_EXECUTE_PHASE_BEFORE_RENDER   EQU 0x00                                    ; фаза выполнения события, перед орисовкой
EVENT_EXECUTE_PHASE_AFTER_RENDER    EQU 0x01                                    ; фаза выполнения события, после отрисовки
EVENT_LIFETIME_ONCE                 EQU 0x00                                    ; время жизни события - выполняется один раз
EVENT_LIFETIME_TIMER                EQU 0x01                                    ; время жизни события - живёт заданное время
EVENT_LIFETIME_CONDITION            EQU 0x02                                    ; время жизни события - живёт пока выполняется условие или до явного удаления

EVENT_EXECUTE_PHASE_BIT             EQU 0x07                                    ; бит, фаза выполнения события
EVENT_BEFORE_RENDER                 EQU EVENT_EXECUTE_PHASE_BEFORE_RENDER << EVENT_EXECUTE_PHASE_BIT
EVENT_AFTER_RENDER                  EQU EVENT_EXECUTE_PHASE_AFTER_RENDER << EVENT_EXECUTE_PHASE_BIT

                endif ; ~_CONST_EVENT_
