
                ifndef _GRAPHICS_UI_SILHOUETTE_MALE_PAPER_DOLL_INCLUDE_
                define _GRAPHICS_UI_SILHOUETTE_MALE_PAPER_DOLL_INCLUDE_

                module PaperDoll
                module Male
                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/UI/Silhouette/PaperDoll_Male.pack", \
                "Builder/Assets/Graphics/Compressed/UI/PaperDoll_Male.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_UI_SILHOUETTE_MALE_PAPER_DOLL_INCLUDE_
