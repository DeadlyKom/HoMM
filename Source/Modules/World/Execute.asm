
                ifndef _MODULE_WORLD_EXECUTE_
                define _MODULE_WORLD_EXECUTE_
; -----------------------------------------
; запуск "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
World:          ; принудительная установка места загрузки ресурса
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_TILE_BIOME_GRASS_SAND, Page.TileSprites, Adr.TileSprites
                LOAD_ASSETS ASSETS_ID_TILE_BIOME_GRASS_SAND                     ; загрузка ресурса графика тайлов биома "трава-песок"

                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_WORLD, Page.World, Adr.World
                LOAD_EXE_ASSETS ASSETS_ID_WORLD                                 ; загрузка ресурса и запуск

                endif ; ~_MODULE_WORLD_EXECUTE_
