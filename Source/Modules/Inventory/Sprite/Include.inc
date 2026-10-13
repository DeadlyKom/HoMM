
                ifndef _MODULE_INVENTORY_SPRITE_INCLUDE_
                define _MODULE_INVENTORY_SPRITE_INCLUDE_

                module Sprite
                DISP Adr.CodeToScr

                display "'Inventory' sprite:\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.CodeToScr, " byte(s) / free ", /D, Size.CodeToScr - Size, "]\t[5]\t ------------------------"

                include "PaperDoll.asm"
Size            EQU $-Adr.CodeToScr

                ENT
                endmodule

                endif ; ~_MODULE_INVENTORY_SPRITE_INCLUDE_
