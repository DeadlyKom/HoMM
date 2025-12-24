
                ifndef _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_
                define _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_

HEXTILE_ID_COUNTER  defl 0                                                      ; счётчик гексагональных тайлов
MAKE_HEXTILE_BIND macro IndexInListGraphicsPackage?, Offset?
                DB IndexInListGraphicsPackage?
                DB Offset?
HEXTILE_ID_COUNTER = HEXTILE_ID_COUNTER+1
                endm

                ; таблица сопоставления гексагональных тайлов и графического пакетов, где
                ;  1. индекс массива - ID гексагонального тайла
                ;  2. первый байт - ID графического пакета
                ;  3. второй байт - смещение внутри текущего графического пакета (0-7)
                ;
                ;   | <---------- первый байт ---------- > |   | <---------- второй байт ---------- >  |
                ;
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |   |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | UD | I6 | I5 | I4 | I3 | I2 | I1 | I0 |   | .. | .. | .. | .. | .. | O2 | O1 | O0 |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;
                ;   UD      [15]        - флаг, использования гесагонального тайла (0 - не используется)
                ;   O2-O0   [13..11]    - смещение внутри текущего графического пакета (0-7)

                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #00              ; 0 гексагональный тайл
                MAKE_HEXTILE_BIND GRAPHICS_PACKAGE_GRASSLANDS, #01              ; 1 гексагональный тайл

                endif ; ~ _METADATA_MAP_DEBUG_HEXAGON_GRAPHICS_PACKAGE_TABLE_
