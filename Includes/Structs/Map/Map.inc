
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
HexTile         FMapDataBlockInfo                                               ; блока данных гексагоных тайлов
GraphicPack     FMapDataBlockInfo                                               ; блок данных необходимого графического пакета для текущей карты
Objects         FMapDataBlockInfo                                               ; блок данных об объектах
Rules           FMapDataBlockInfo                                               ; блок данных об правилах (ToDo)
; DefaultSettings DB #00                                                          ; ассет ID дефолтных настроек объектов (пока непонятно как с ними работать в новой концепции)

                ends

                endif ; ~_STRUCT_MAP_
