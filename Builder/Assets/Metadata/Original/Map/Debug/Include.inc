
                ifndef _METADATA_MAP_DEBUG_
                define _METADATA_MAP_DEBUG_

                module Debug

                ORG #0000
                
                ; FMapHeader
                lua allpass
                local width, height = ConvertTMX_Hex("Tools/Tiled/DebugHex.tmx", "Builder/Assets/Metadata/Original/Map/Debug/Block.Hextile.bin")
                _pc("DB " .. width)                                             -- FMapHeader.Size.X
                _pc("DB " .. height)                                            -- FMapHeader.Size.Y
                endlua
                DB #00                                                          ; FMapHeader.Info.Participants (доступное количество участников на карте)

                FMapDataBlockInfo { Hextile.Size, Hextile-$-2 }                 ; блока данных гексагоных тайлов
                FMapDataBlockInfo { HextileTable.Size, HextileTable-$-2}        ; блок данных таблицы сопоставления гексагональных тайлов и графического пакетов
                FMapDataBlockInfo { GraphPackage.Size, GraphPackage-$-2}        ; блок данных необходимого графического пакета для текущей карты
                FMapDataBlockInfo { Objects.Size, Objects-$-2}                  ; блок данных об объектах
                FMapDataBlockInfo {}                                            ; блок данных об правилах (ToDo)

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
                savebin "Builder/Assets/Metadata/Original/Map/Debug.map", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Metadata/Original/Map/Debug.map Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _METADATA_MAP_DEBUG_
