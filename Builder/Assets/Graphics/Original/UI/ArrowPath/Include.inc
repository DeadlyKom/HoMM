
                ifndef _GRAPHICS_UI_ARROW_PATH_PACK_INCLUDE_
                define _GRAPHICS_UI_ARROW_PATH_PACK_INCLUDE_

                module Graphics
                module ArrowPath

                ORG #0000
                
                include "ArrowPath.inc"
Size            EQU $
                savebin "Builder/Assets/Graphics/Original/UI/ArrowPath.pack", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/UI/ArrowPath.pack Builder/Assets/Graphics/Compressed/UI_ArrowPath.pack.ar"
                ASSETS_SIZE "Builder/Assets/Graphics/Compressed/UI_ArrowPath.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_UI_ARROW_PATH_PACK_INCLUDE_
