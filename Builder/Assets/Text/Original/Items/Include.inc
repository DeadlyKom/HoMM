
                ifndef _TEXT_ITEMS_INCLUDE_
                define _TEXT_ITEMS_INCLUDE_

                module Items
                ORG #0000
Begin:          EQU $
ITEM_NAME_ID_COUNTER defl 0
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Text/Original/Items/Items.pack", \
                "Builder/Assets/Text/Compressed/Items.pack.ar"
                endmodule

                endif ; ~_TEXT_ITEMS_INCLUDE_

