
                ifndef _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_
                define _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_

                ; таблица сопоставления гексагональных тайлов и графического пакетов, где
                ;  1. индекс массива - ID гексагонального тайла
                ;  2. первый байт - индекс в массиве FMapHeader.GraphicPack
                ;  3. второй байт - смещение внутри текущего графического пакета (0-7)
                ;
                ;   | <---------- первый байт ---------- > |   | <---------- второй байт ---------- >  |
                ;
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |   |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | UB | I6 | I5 | I4 | I3 | I2 | I1 | I0 |   | O2 | O1 | O0 | .. | .. | .. | .. | .. |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;
                ;   UB      [15]        - флаг, использования гексагонального тайла (1 - не используется)
                ;   I6-I0   [14..8]     - ндекс в массиве FMapHeader.GraphicPack
                ;   O2-O0   [7..5]      - смещение внутри текущего графического пакета (0-7)

                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #00              ; 0 
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #01              ; 1 
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #02              ; 2
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #03              ; 3
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #04              ; 4
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #05              ; 5
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #06              ; 6
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #07              ; 7
                ; HEXTILE_NOT_USABLE                                              ; 8 - не используется

                endif ; ~ _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_
