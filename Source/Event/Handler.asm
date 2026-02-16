
                ifndef _EVENT_HANDLER_
                define _EVENT_HANDLER_
; -----------------------------------------
; обработчик событий
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Handler:        ; количество обрабатываемых событий
                LD A, (GameSession.WorldInfo + FWorldInfo.EventNum)             ; количество элементов в массиве
                OR A
                RET Z                                                           ; выход, если нет элементов в массиве
                
                ; инициализация
                LD B, A
                LD IX, Adr.EventArray                                           ; стартовый адрес массива событий

.Loop           PUSH BC
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                ; проверка фазы выполнения события
                BIT EVENT_EXECUTE_PHASE_BIT, (IX + FEvent.Flags)
                JR NZ, .NextEvent                                               ; переход, если событие после отрисовки


.NextEvent      ; следующий элемент
                LD BC, EVENT_SIZE
                ADD IX, BC

                ; уменьшение счётчика элементов
                POP BC
                DJNZ .Loop

                RET

                display " - Handler event:\t\t\t\t\t\t", /A, Handler, "\t= busy [ ", /D, $-Handler, " byte(s)  ]"

                endif ; ~_EVENT_HANDLER_
