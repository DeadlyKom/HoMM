
                ifndef _STRUCT_MAP_
                define _STRUCT_MAP_

                struct FMapInfo
Size            FSize                                                           ; размер карты
Participants    DB #00                                                          ; доступное количество участников на карте
                ends

                struct FMapHeader                                               ; заголовок карты
Info            FMapInfo                                                        ; базовая информация о карте
BiomeID         DB #00                                                          ; ассет ID тайлового биома
BiomeSize       DW #0000                                                        ; длина блока данных биома
BiomeOffset     DW #0000                                                        ; смещение до данных биома
DefaultSettings DB #00                                                          ; ассет ID дефолтных настроек объектов
GraphicPack     DB #00                                                          ; ассет ID необходимого графического пакета для текущей карты
ObjectNum       DB #00                                                          ; количество объектов на карте
ObjectOffset    DW #0000                                                        ; смещение до данных объектов
Rules           DW #0000                                                        ; ToDo: правила игры на карте
                ends

                endif ; ~_STRUCT_MAP_
