
                ifndef _STRUCTS_EVENT_RECONNAISSANCE_
                define _STRUCTS_EVENT_RECONNAISSANCE_

                struct FEventReconnaissance                                     ; структура события рекогносцировки, 9 байт
Super           FEvent                                                          ; базовая структура события
Group           DB #00                                                          ; группа владельца персонажа
Position        FVector8                                                        ; координаты рекогносцировки
Radius          DB #00                                                          ; радиус обзора персонажа в тайлах
                ends

                endif ; ~_STRUCTS_EVENT_RECONNAISSANCE_
