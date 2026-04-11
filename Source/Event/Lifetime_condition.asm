
                ifndef _EVENT_HANDLER_LIFETIME_CONDITION_
                define _EVENT_HANDLER_LIFETIME_CONDITION_
; -----------------------------------------
; обработчик событий (время жизни события - живёт пока выполняется условие или до явного удаления)
; In:
;   IY - указывает на структуру FEvent
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 7)
; -----------------------------------------
Lifetime.Cond:  JP RemoveAtSwap

                display " - Lifetime event 'condition':\t\t\t", /A, Lifetime.Cond, "\t= busy [ ", /D, $-Lifetime.Cond, " byte(s)  ]"

                endif ; ~_EVENT_HANDLER_LIFETIME_CONDITION_
