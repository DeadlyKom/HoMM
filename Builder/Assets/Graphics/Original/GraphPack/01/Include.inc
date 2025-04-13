
                ifndef _GRAPHICS_PACK_01_INCLUDE_
                define _GRAPHICS_PACK_01_INCLUDE_

                module Pack_01

                ORG #0000
                
                include "Pack.inc"
Size            EQU $
                savebin "Builder/Assets/Graphics/Original/GraphPack/01.pack", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/GraphPack/01.pack Builder/Assets/Graphics/Compressed/GraphPack/01.pack.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Graphics/Compressed/GraphPack/01.pack.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)
                endmodule

                endif ; ~ _GRAPHICS_PACK_01_INCLUDE_
