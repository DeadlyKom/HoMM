
                ifndef _PAGE_1_BUFFERS_
                define _PAGE_1_BUFFERS_
Buffer:
.Render         EQU Page1.Buffer.RenderBuffer                                   ; обновление Render-буфера
.Memcpy.Tilemap EQU Page1.Buffer.Memcpy.TilemapBuffer                           ; копирование блока тайлов в Tile-буфер

BufferUtilities:
.GetRender      EQU Page1.Buffer.GetRenderBuffer                                ; определение адреса Render-буфера по индексу гексагона
.UpdateHextile  EQU Page1.Buffer.Hextile                                        ; обновление Render-буфера указанного гексогонального тайла
.Reconnaissance EQU Page1.Buffer.Reconnaissance                                 ; рекогносцировка
                endif ; ~_PAGE_1_BUFFERS_
