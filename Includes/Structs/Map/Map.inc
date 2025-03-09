
                ifndef _STRUCT_MAP_
                define _STRUCT_MAP_

                struct FMapHeader                                               ; заголовок карты
Size            FSize                                                           ; размер карты
PlayersMAX      DB #00                                                          ; максимальное количество игроков на карте
BiomeID         DB #00                                                          ; ассета ID тайлового биома
BiomeOffset     DW #0000                                                        ; смещение до данных биома
ObjectNum       DB #00                                                          ; количество объектов на карте
ObjectOffset    DW #0000                                                        ; смещение до данных объектов
Rules           DW #0000                                                        ; ToDo: правила игры на карте
                ends

                endif ; ~_STRUCT_MAP_
