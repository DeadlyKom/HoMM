
                ifndef _GRAPHICS_PACK_01_INCLUDE_
                define _GRAPHICS_PACK_01_INCLUDE_

                module Pack_01

                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/GraphPack/01.pack", \
                "Builder/Assets/Graphics/Compressed/GraphPack/01.pack.ar"
                endmodule

                endif ; ~ _GRAPHICS_PACK_01_INCLUDE_
