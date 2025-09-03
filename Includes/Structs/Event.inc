
                ifndef _STRUCTS_EVENT_
                define _STRUCTS_EVENT_

                struct FEvent                                                   ; структура описывающая собитие
Type            DB #00                                                          ; тип события
HeroID          DB #00                                                          ; идентификатор активного героя
Position        FVector8                                                        ; позиция курсора,
                                                                                ; в зависимости от типа нажатой клавиши значения могут быть разные
                ends

                endif ; ~_STRUCTS_EVENT_
