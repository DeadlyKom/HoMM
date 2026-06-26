
                ifndef _GRAPHICS_HERO_PACK_INCLUDE_
                define _GRAPHICS_HERO_PACK_INCLUDE_

                module Graphics
                module Hero

                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/Hero/Hero.pack", \
                "Builder/Assets/Graphics/Compressed/Hero.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_HERO_PACK_INCLUDE_
