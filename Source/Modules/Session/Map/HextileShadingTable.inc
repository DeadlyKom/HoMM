
                ifndef _MODULE_SESSION_MAP_HEXTILE_SHADING_TABLE_
                define _MODULE_SESSION_MAP_HEXTILE_SHADING_TABLE_
HexShadingTable ; таблица соответствия ID гексагонального тайла и номера штриховка
                DB #00 * 2  ; 0 - трава
                DB #01 * 2  ; 1 - гора
                DB #00 * 2  ; 2 - болото
                DB #00 * 2  ; 3 - деревня
                DB #00 * 2  ; 4 - лес 1
                DB #00 * 2  ; 5 - лес 2
                DB #00 * 2  ; 6 - укреп
.Size           EQU $-HexShadingTable

                endif ; ~_MODULE_SESSION_MAP_HEXTILE_SHADING_TABLE_
