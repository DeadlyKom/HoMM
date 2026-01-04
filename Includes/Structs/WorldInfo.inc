
                ifndef _STRUCT_WORLD_INFO_
                define _STRUCT_WORLD_INFO_

                struct FWorldInfo                                               ; информация о мире                                             [байт]
MapPosition     FVector8                                                        ; позиция тайловой карты в гексагонах
                                                                                ; левый-верхний край                                            [2 байта]
MapOffset       FVector8                                                        ; смещение внутри гексагона                                     [2 байта]
Tilemap         DW #0000                                                        ; адрес тайловой карты
                                                                                ; левый-верхний край                                            [2 байта]
HeroNum         DB #00                                                          ; количество героев на карте                                    [1 байта]
ObjectNum       DB #00                                                          ; количество объектов на карте                                  [1 байта]

                ends

                endif ; ~_STRUCT_WORLD_INFO_
