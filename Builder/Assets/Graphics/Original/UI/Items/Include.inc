
                ifndef _GRAPHICS_UI_ITEMS_INCLUDE_
                define _GRAPHICS_UI_ITEMS_INCLUDE_

                module Items
                ORG #0000
Begin:          EQU $
                include "Header.inc"
                include "Belt/Pack.inc"
                include "Boot/Pack.inc"
                include "Head/Pack.inc"
                include "Ring/Pack.inc"
                include "Amulet/Pack.inc"
                include "Breast/Pack.inc"
                include "Shield/Pack.inc"
                include "Weapon/Pack.inc"
                include "ShoulderPad/Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/UI/Items/Items.pack", \
                "Builder/Assets/Graphics/Compressed/UI/Items.pack.ar"
                endmodule

                endif ; ~_GRAPHICS_UI_ITEMS_INCLUDE_

