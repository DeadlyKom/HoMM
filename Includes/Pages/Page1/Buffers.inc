
                ifndef _PAGE_1_BUFFERS_
                define _PAGE_1_BUFFERS_
UpdateBuffer:
.Render         EQU Page1.Update.RenderBuffer                                   ; обновление Render-буфера
.Tilemap        EQU Page1.Update.Memcpy.TilemapBuffer                           ; копирование блока тайлов в Tile-буфер

                endif ; ~_PAGE_1_BUFFERS_
