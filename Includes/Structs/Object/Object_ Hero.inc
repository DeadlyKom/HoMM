
                ifndef _STRUCT_OBJECT_
                define _STRUCT_OBJECT_

                struct FObjectHero                                              ; объект                                                    [10 байт]

Super           FObject                                                         ; базовый класс объекта                                     [9 байт]
HeroID          DB #00                                                          ; идентификатор владельца, указатель на структуру FHero     [1 байт]
                ends

                endif ; ~_STRUCT_OBJECT_
