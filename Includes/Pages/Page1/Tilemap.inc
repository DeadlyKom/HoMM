
                ifndef _PAGE_1_TILEMAP_
                define _PAGE_1_TILEMAP_
Tilemap:
.UpdateBuffers  EQU Page1.Tilemap.UpdateBuffers                                 ; обновление Tilemap- и Render-буферов
.Memcpy         EQU Page1.Tilemap.Memcpy.TilemapBuffer                          ; копирование блока тайлов в рендер буфер

                endif ; ~_PAGE_1_TILEMAP_
