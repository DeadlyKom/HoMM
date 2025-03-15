
                ifndef _STRUCT_WORLD_INFO_
                define _STRUCT_WORLD_INFO_

                struct FWorldInfo                                               ; информация о мире                                             [байт]
MapPosition     FVector8                                                        ; позиция такйловой карты в знакоместах
                                                                                ; левый-верхний край                                            [2 байта]
Tilemap         DW #0000                                                        ; адрес тайловой карты
                                                                                ; левый-верхний край                                            [2 байта]
                ends

                endif ; ~_STRUCT_WORLD_INFO_
