
                ifndef _METADATA_MAP_DEBUG_
                define _METADATA_MAP_DEBUG_

                module Debug

                ORG #0000
                
                ; FMapHeader
                lua allpass
                local width, height = ConvertMapTilded("Tools/Tiled/DebugMap.tmx", "Builder/Assets/Metadata/Original/Map/Debug.array")
                _pc("DB " .. width)                                             -- FMapHeader.Size.X
                _pc("DB " .. height)                                            -- FMapHeader.Size.Y
                endlua

                DB #00                                                          ; FMapHeader.Info.PlayersMAX
                DB ASSETS_ID_TILE_BIOME_GRASS_SAND                              ; FMapHeader.BiomeID
                DW Tile.Size                                                    ; FMapHeader.BiomeSize
                DW Tile-$-1                                                     ; FMapHeader.BiomeOffset
                DB #00                                                          ; FMapHeader.ObjectNum
                DW #0000                                                        ; FMapHeader.ObjectOffset
                DW #0000                                                        ; FMapHeader.Rules

Tile            incbin "Builder/Assets/Metadata/Original/Map/Debug.array"
Tile.Size       EQU $-Tile
Size            EQU $
                savebin "Builder/Assets/Metadata/Original/Map/Debug.map", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Metadata/Original/Map/Debug.map Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _METADATA_MAP_DEBUG_
