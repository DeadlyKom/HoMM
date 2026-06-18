
                ifndef _GRAPHICS_HERO_PACK_INCLUDE_
                define _GRAPHICS_HERO_PACK_INCLUDE_

                module Graphics
                module Hero

                ORG #0000
                
                include "Pack.inc"
Size            EQU $
                savebin "Builder/Assets/Graphics/Original/Hero/Hero.pack", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/Hero/Hero.pack Builder/Assets/Graphics/Compressed/Hero.pack.ar"
                ASSETS_SIZE "Builder/Assets/Graphics/Compressed/Hero.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_HERO_PACK_INCLUDE_
