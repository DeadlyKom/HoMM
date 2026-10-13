
                ifndef _GRAPHICS_UI_SILHOUETTE_FEMALE_PAPER_DOLL_INCLUDE_
                define _GRAPHICS_UI_SILHOUETTE_FEMALE_PAPER_DOLL_INCLUDE_

                module PaperDoll
                module Female
                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/UI/Silhouette/PaperDoll_Female.pack", \
                "Builder/Assets/Graphics/Compressed/UI/PaperDoll_Female.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_UI_SILHOUETTE_FEMALE_PAPER_DOLL_INCLUDE_
