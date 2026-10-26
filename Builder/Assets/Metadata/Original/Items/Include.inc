
                ifndef _METADATA_ITEMS_INCLUDE_
                define _METADATA_ITEMS_INCLUDE_

                module Items
                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Metadata/Original/Items/Items.pack", \
                "Builder/Assets/Metadata/Compressed/Items.pack.ar"
                endmodule

                endif ; ~_METADATA_ITEMS_INCLUDE_

