
                ifndef _BUFFERS_INCLUDE_
                define _BUFFERS_INCLUDE_

; Блок кода расположенный в странице рядом с массивами карты и метаданнхы,
; итилиты:
;   - работа с массивоми Render-буфера и Tilemap-буфером
;   - определения координат в буфере
                module Buffer
                include "RenderBuffer.asm"
                include "UpdateHextile.asm"
                include "Reconnaissance.asm"
                include "UpdateSpriteBound.asm"
                include "Utilities/Include.inc"
                include "AdjustRenderBufferColumns.asm"
                include "Source/Memory/MemcpyTilemapBuffer.asm"
                endmodule

                endif ; ~_BUFFERS_INCLUDE_
