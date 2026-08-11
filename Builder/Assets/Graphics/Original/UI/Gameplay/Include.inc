
                ifndef _GRAPHICS_UI_GAMEPLAY_INCLUDE_
                define _GRAPHICS_UI_GAMEPLAY_INCLUDE_

                module Gameplay
                include "Screen/Include.inc"

                module Common                                                   ; ASSETS_ID_UI_GAMEPLAY_COMMON_PACK
                ORG #0000
Begin:          EQU $
                include "Pack_Common.inc"
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/UI/Gameplay/Common.pack", \
                "Builder/Assets/Graphics/Compressed/UI/Common.pack.ar"

                endmodule
                endmodule


                endif ; ~ _GRAPHICS_UI_GAMEPLAY_INCLUDE_
