
                ifndef _STRUCTS_EVENT_RECONNAISSANCE_
                define _STRUCTS_EVENT_RECONNAISSANCE_

                struct FEventReconnaissance                                     ; структура описывающая собитие "разведка"                  [9 байт]
Super           FEvent                                                          ; базовый класс объекта                                     [6 байта]
HeroID          DB #00                                                          ; идентификатор игрока                                      [1 байт]
Position        FVector8                                                        ; позиция эвента                                            [2 байта]
                ends

                endif ; ~_STRUCTS_EVENT_RECONNAISSANCE_
