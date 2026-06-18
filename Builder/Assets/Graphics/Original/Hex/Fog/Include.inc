
                ifndef _GRAPHICS_HEXAGON_FOG_INCLUDE_
                define _GRAPHICS_HEXAGON_FOG_INCLUDE_

                module Fog                                                      ; туман
                ORG #0000
                include "CreateSprites.inc"
                
                ORG #0000
Begin           EQU $
                include "Pack.inc"
Size            EQU $-Begin
                savebin "Builder/Assets/Graphics/Original/Hex/Fog/Pack.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/Hex/Fog/Pack.pack Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar"
                ASSETS_SIZE "Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar"
                endmodule

                endif ; ~ _GRAPHICS_HEXAGON_FOG_INCLUDE_
