
                ifndef _KERNEL_EVENT_
                define _KERNEL_EVENT_
Event
.Add            EQU Kernel.Event.Add                                            ; добавить событие
.Handler        EQU Kernel.Event.Handler                                        ; обработчик событий
.Initialize     EQU Kernel.Event.Initialize                                     ; инициализация работы с событиями
.PlacemantNew   EQU Kernel.Event.PlacemantNew                                   ; размещение нового объекта
.RemoveAtSwap   EQU Kernel.Event.RemoveAtSwap                                   ; удаление события, перемещая последний элемент в массиве

                endif ; ~_KERNEL_EVENT_
