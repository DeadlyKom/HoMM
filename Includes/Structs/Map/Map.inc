
                ifndef _STRUCT_MAP_
                define _STRUCT_MAP_

                struct FMapInfo                                                 ; базовая информация о карте
Size            FSize                                                           ; размер карты
Participants    DB #00                                                          ; доступное количество участников на карте
                ends

                struct FMapDataBlockInfo                                        ; информация о блоке данных карты
Size            DW #0000                                                        ; размер блока
Offset          DW #0000                                                        ; смещение до блока данных
                ends

                struct FMapHeader                                               ; заголовок карты
Info            FMapInfo                                                        ; базовая информация о карте
Hextile         FMapDataBlockInfo                                               ; блока данных гексагоных тайлов
HextileTable    FMapDataBlockInfo                                               ; блок данных таблицы сопоставления гексагонального тайла и графического пакета
GraphicPack     FMapDataBlockInfo                                               ; блок данных необходимых графических пакетов для текущей карты
Objects         FMapDataBlockInfo                                               ; блок данных об объектах
Rules           FMapDataBlockInfo                                               ; блок данных об правилах (ToDo)

                ends

                endif ; ~_STRUCT_MAP_
