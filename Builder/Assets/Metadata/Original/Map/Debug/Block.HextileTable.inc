
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

                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #00              ; HextileID 0: трава,               sprite_1,  Tiled GID 23
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #01              ; HextileID 1: гора,                sprite_4,  Tiled GID 160
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #02              ; HextileID 2: болото,              sprite_6,  Tiled GID 137
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #03              ; HextileID 3: маленькое поселение, sprite_10, Tiled GID 133
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #04              ; HextileID 4: лес в центре гекса,  sprite_8,  Tiled GID 46
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #05              ; HextileID 5: плотный лес,         sprite_2,  Tiled GID 48
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #06              ; HextileID 6: укрепление,          sprite_3,  Tiled GID 111
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #07              ; HextileID 7: пустой гекс/контур,  outline,   Tiled GID 0
                ; HEXTILE_NOT_USABLE                                              ; 8 - не используется

                endif ; ~ _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_
