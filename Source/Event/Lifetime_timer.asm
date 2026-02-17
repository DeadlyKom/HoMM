
                ifndef _EVENT_HANDLER_LIFETIME_TIMER_
                define _EVENT_HANDLER_LIFETIME_TIMER_
; -----------------------------------------
; обработчик событий (время жизни события - живёт заданное время)
; In:
;   IY - указывает на структуру FEvent
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Lifetime.Timer: JP RemoveAtSwap

                display " - Lifetime event 'timer':\t\t\t\t", /A, Lifetime.Timer, "\t= busy [ ", /D, $-Lifetime.Timer, " byte(s)  ]"

                endif ; ~_EVENT_HANDLER_LIFETIME_TIMER_
