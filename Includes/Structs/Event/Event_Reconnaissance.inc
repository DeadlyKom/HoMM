
                ifndef _STRUCTS_EVENT_RECONNAISSANCE_
                define _STRUCTS_EVENT_RECONNAISSANCE_

                struct FEventReconnaissance                                     ; структура описывающая собитие "разведка"                  [8 байт]
Super           FEvent                                                          ; базовый класс объекта                                     [5 байта]
FogMask         DB #00                                                          ; маска видимости участников одной группы в метаданных карты  [1 байт]
Position        FVector8                                                        ; позиция ивента                                            [2 байта]
                ends

                endif ; ~_STRUCTS_EVENT_RECONNAISSANCE_
