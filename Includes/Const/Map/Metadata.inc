
                ifndef _CONST_MAP_METADATA_
                define _CONST_MAP_METADATA_
; флаги работы с метаданными карты
MAP_META_BLOCK_TILE_BIT     EQU 0x07                                            ; флаг, невозможности проходить данный тайл
MAP_META_CLOSE_LIST_BIT     EQU 0x06                                            ; флаг, указывает нахождение тайла в закрытом списке (исключает из обработки в поиске пути)
MAP_META_FOG_OF_WAR_MASK    EQU %00001111                                       ; биты тумана войны, соответствующие каждому игроку
MAP_META_BLOCK_TILE         EQU 1 << MAP_META_BLOCK_TILE_BIT
MAP_META_CLOSE_LIST         EQU 1 << MAP_META_CLOSE_LIST_BIT

                endif ; ~_CONST_MAP_METADATA_
