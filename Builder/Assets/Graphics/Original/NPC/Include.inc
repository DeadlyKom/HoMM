
                ifndef _GRAPHICS_AXEMAN_PACK_INCLUDE_
                define _GRAPHICS_AXEMAN_PACK_INCLUDE_

                module Graphics
                module NPC.Axeman

                ORG #0000
                
                include "Pack.inc"
Size            EQU $
                savebin "Builder/Assets/Graphics/Original/NPC/Axeman/Axeman.pack", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/NPC/Axeman/Axeman.pack Builder/Assets/Graphics/Compressed/Axeman.pack.ar"
                ASSETS_SIZE "Builder/Assets/Graphics/Compressed/Axeman.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_AXEMAN_PACK_INCLUDE_
