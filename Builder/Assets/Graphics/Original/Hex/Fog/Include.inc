
                ifndef _GRAPHICS_HEXAGON_FOG_INCLUDE_
                define _GRAPHICS_HEXAGON_FOG_INCLUDE_

                module Fog                                                      ; туман
                ORG #0000
                include "CreateSprites.inc"
                
                ORG #0000
Begin           EQU $
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/Hex/Fog/Pack.pack", \
                "Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar"
                endmodule

                endif ; ~ _GRAPHICS_HEXAGON_FOG_INCLUDE_
