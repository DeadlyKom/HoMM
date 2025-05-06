
                ifndef _MODULE_WORLD_SPRITE_INCLUDE_
                define _MODULE_WORLD_SPRITE_INCLUDE_

                module Sprite
                DISP Adr.CodeToScr

                display "'World\' sprite:\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.CodeToScr, " byte(s) / free ", /D, Size.CodeToScr - Size, "]\t[5]\t ------------------------"

                include "Hero.asm"
                include "Cursor.asm"
Size            EQU $-Adr.CodeToScr

                ENT
                endmodule

                endif ; ~_MODULE_WORLD_SPRITE_INCLUDE_
