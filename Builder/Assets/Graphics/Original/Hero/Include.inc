
                ifndef _GRAPHICS_HERO_PACK_INCLUDE_
                define _GRAPHICS_HERO_PACK_INCLUDE_

                module Graphics
                module Hero

                ORG #0000
                
                include "Hero.inc"
Size            EQU $
                savebin "Builder/Assets/Graphics/Original/Hero.pack", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/Hero.pack Builder/Assets/Graphics/Compressed/Hero.pack.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Graphics/Compressed/Hero.pack.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_HERO_PACK_INCLUDE_
