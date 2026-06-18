
                ifndef _GRAPHICS_CURSOR_PACK_INCLUDE_
                define _GRAPHICS_CURSOR_PACK_INCLUDE_

                module Graphics
                module Cursor

                ORG #0000
Begin:          EQU $
                include "Pack.inc"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/Cursor/Cursor.pack", \
                "Builder/Assets/Graphics/Compressed/Cursor.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_CURSOR_PACK_INCLUDE_
