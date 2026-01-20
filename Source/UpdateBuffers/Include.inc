
                ifndef _UPDATE_BUFFERS_INCLUDE_
                define _UPDATE_BUFFERS_INCLUDE_

                module Update

                include "RenderBuffer.asm"
                include "UpdateHextile.asm"
                include "GetRenderBufferByIndex.asm"
                include "Source/Memory/MemcpyTilemapBuffer.asm"

                endmodule

                endif ; ~_UPDATE_BUFFERS_INCLUDE_
