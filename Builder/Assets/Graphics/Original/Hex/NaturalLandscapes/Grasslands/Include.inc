
                ifndef _GRAPHICS_HEXAGON_GRASSLANDS_INCLUDE_
                define _GRAPHICS_HEXAGON_GRASSLANDS_INCLUDE_

                module Grasslands                                               ; луга
                ORG #0000
                include "CreateSprites.inc"

                ORG #0000
Begin           EQU $
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/Hex/NaturalLandscapes/Grasslands/Pack.pack", \
                "Builder/Assets/Graphics/Compressed/Hex/Grasslands.pack.ar"
                endmodule

                endif ; ~ _GRAPHICS_HEXAGON_GRASSLANDS_INCLUDE_
