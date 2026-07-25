
                ifndef _GRAPHICS_AXEMAN_PACK_INCLUDE_
                define _GRAPHICS_AXEMAN_PACK_INCLUDE_

                module Graphics
                module NPC.Axeman

                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/NPC/Axeman/Axeman.pack", \
                "Builder/Assets/Graphics/Compressed/Axeman.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_AXEMAN_PACK_INCLUDE_
