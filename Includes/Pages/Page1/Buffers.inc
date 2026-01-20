
                ifndef _PAGE_1_BUFFERS_
                define _PAGE_1_BUFFERS_
UpdateBuffer:
.Render         EQU Page1.Update.RenderBuffer                                   ; обновление Render-буфера
.Tilemap        EQU Page1.Update.Memcpy.TilemapBuffer                           ; копирование блока тайлов в Tile-буфер

UtilsBuffer:
.GetRender      EQU Page1.Update.GetRenderBuffer                                ; обновление адреса Render-буфера по индексу гексагона
.UpdateHextile  EQU Page1.Update.Hextile
                endif ; ~_PAGE_1_BUFFERS_
