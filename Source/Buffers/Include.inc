
                ifndef _BUFFERS_INCLUDE_
                define _BUFFERS_INCLUDE_

                module Buffer
                include "RenderBuffer.asm"
                include "UpdateHextile.asm"
                include "Reconnaissance.asm"
                include "GetRenderBufferByIndex.asm"
                include "Source/Memory/MemcpyTilemapBuffer.asm"
                endmodule

                endif ; ~_BUFFERS_INCLUDE_
