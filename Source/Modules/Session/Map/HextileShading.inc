
                ifndef _MODULE_SESSION_MAP_HEXTILE_SHADING_
                define _MODULE_SESSION_MAP_HEXTILE_SHADING_
HexShading:     ; текстура штриховка тайла (8 байт на тайл)
._0             DB %00000000
                DB %00000000

._1             DB %01010101
                DB %10101010

._2             DB %00010001
                DB %10001000

._3             DB %11111111
                DB %11111111
.Size           EQU $-HexShading

                endif ; ~_MODULE_SESSION_MAP_HEXTILE_SHADING_
