
                ifndef _METADATA_MAP_DEBUG_
                define _METADATA_MAP_DEBUG_

                module Debug

                ORG #0000
Begin:          EQU $
                ; FMapHeader
                lua allpass
                local width, height = ConvertTMX_Hex("Tools/Tiled/DebugHex.tmx", "Builder/Assets/Metadata/Original/Map/Debug/Block.Hextile.bin")
                _pc("DB " .. width)                                             -- FMapHeader.Size.X
                _pc("DB " .. height)                                            -- FMapHeader.Size.Y
                endlua
                DB #00                                                          ; FMapHeader.Info.Participants (доступное количество участников на карте)

                FMapDataBlockInfo {}                                            ; блок данных - список "точек спавна",
                                                                                ; если отсутствует, автоматическое формирование 
                FMapDataBlockInfo { Hextile.Size, Hextile-$-2 }                 ; блок данных - гексагоных тайлов
                FMapDataBlockInfo {}                                            ; блок данных - метаданные карты
                FMapDataBlockInfo {}                                            ; блок данных - свойство гексагоных тайлов
                FMapDataBlockInfo { HextileTable.Size, HextileTable-$-2}        ; блок данных - таблицы сопоставления гексагональных тайлов и графического пакетов
                FMapDataBlockInfo { GraphPackage.Size, GraphPackage-$-2}        ; блок данных - необходимого графического пакета для текущей карты
                FMapDataBlockInfo { Objects.Size, Objects-$-2}                  ; блок данных - об объектах
                FMapDataBlockInfo {}                                            ; блок данных - об правилах (ToDo)

                ; массив индексов гексагональных тайлов (карта)
Hextile         incbin "Block.Hextile.bin"
Hextile.Size    EQU $-Hextile

                ; таблица гексагональных тайлов, для сопоставления индекса тайла с ID графического пакета и смещением внутри него
HextileTable    include "Block.HextileTable.inc"
HextileTable.Size EQU $-HextileTable

                ; список идентификаторов графических пакетов
GraphPackage    include "Block.list_graphID.inc"
GraphPackage.Size EQU $-GraphPackage

                ; список объектов на карте
Objects         include "Block.Object.inc"
Objects.Size    EQU $-Objects
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Metadata/Original/Map/Debug.map", \
                "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"
                endmodule

                endif ; ~ _METADATA_MAP_DEBUG_
