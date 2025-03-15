
                ifndef _PAGE_0_TILEMAP_
                define _PAGE_0_TILEMAP_
Tilemap:
.Update         EQU Page0.Memcpy.Tilemap                                        ; копирование блока тайлов в рендер буфер

                endif ; ~_PAGE_0_TILEMAP_
