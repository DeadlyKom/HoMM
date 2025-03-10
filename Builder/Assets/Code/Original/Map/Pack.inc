
                ifndef _CODE_MAP_PACK_
                define _CODE_MAP_PACK_

                ; - компиляция модуля

                MMU 2, Page.Map
                ORG Adr.Map
                module Map

                display "\'Map\':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Map, "]\t ------------------------"
Begin:          EQU $
                include "Source/Modules/Map/Include.inc"
Size:           EQU $-Begin                                                     ; размер кода
                
                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Map/Map.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Map/Map.pack Builder/Assets/Code/Compressed/Map.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Map.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_MAP_PACK_
