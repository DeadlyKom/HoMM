
                ifndef _KERNEL_EVENT_
                define _KERNEL_EVENT_
Event
.Add            EQU Kernel.Event.Add                                            ; добавить событие
.Handler.Before EQU Kernel.Event.Handler.Before                                 ; обработчик событий (BEFORE_RENDER)
.Handler.After  EQU Kernel.Event.Handler.After                                  ; обработчик событий (AFTER_RENDER)
.Initialize     EQU Kernel.Event.Initialize                                     ; инициализация работы с событиями
.PlacemantNew   EQU Kernel.Event.PlacemantNew                                   ; размещение нового объекта
.RemoveAtSwap   EQU Kernel.Event.RemoveAtSwap                                   ; удаление события, перемещая последний элемент в массиве

                endif ; ~_KERNEL_EVENT_
