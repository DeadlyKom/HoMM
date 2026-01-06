
                ifndef _TILEMAP_INCLUDE_
                define _TILEMAP_INCLUDE_

                module Tilemap

                include "UpdateBuffers.asm"                                     ; (0)
                include "Source/Memory/MemcpyTilemapBuffer.asm"                 ; (1)

                endmodule

                endif ; ~_TILEMAP_INCLUDE_
