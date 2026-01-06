
                ifndef _GRAPHICS_HEXAGON_FOG_INCLUDE_
                define _GRAPHICS_HEXAGON_FOG_INCLUDE_

                module Fog                                                      ; туман
                ORG #0000
Begin           EQU $
                include "Pack.inc"
Size            EQU $-Begin
                savebin "Builder/Assets/Graphics/Original/Hex/Fog/Pack.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/Hex/Fog/Pack.pack Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)
                endmodule

                endif ; ~ _GRAPHICS_HEXAGON_FOG_INCLUDE_
