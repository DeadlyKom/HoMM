
                ifndef _EVENT_HANDLER_LIFETIME_ONCE_
                define _EVENT_HANDLER_LIFETIME_ONCE_
; -----------------------------------------
; обработчик событий (время жизни события - выполняется один раз)
; In:
;   IY - указывает на структуру FEvent
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 7)
; -----------------------------------------
Lifetime.Once:  JP RemoveAtSwap

                display " - Lifetime event 'once':\t\t\t\t", /A, Lifetime.Once, "\t= busy [ ", /D, $-Lifetime.Once, " byte(s)  ]"

                endif ; ~_EVENT_HANDLER_LIFETIME_ONCE_
