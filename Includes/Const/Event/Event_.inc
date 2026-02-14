
                ifndef _CONST_EVENT_
                define _CONST_EVENT_
; флаги FEvent.Flags 
EVENT_EXECUTE_PHASE_BEFORE_RENDER   EQU 0x00                                    ; фаза выполнения события, перед орисовкой
EVENT_EXECUTE_PHASE_AFTER_RENDER    EQU 0x01                                    ; фаза выполнения события, после отрисовки
EVENT_LIFETIME_ONCE                 EQU 0x00                                    ; время жизни события - выполняется один раз
EVENT_LIFETIME_TIMER                EQU 0x01                                    ; время жизни события - живёт заданное время
EVENT_LIFETIME_CONDITION            EQU 0x02                                    ; время жизни события - живёт пока выполняется условие или до явного удаления

                endif ; ~_CONST_EVENT_
