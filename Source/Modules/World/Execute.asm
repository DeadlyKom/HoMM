
                ifndef _MODULE_WORLD_EXECUTE_
                define _MODULE_WORLD_EXECUTE_
; -----------------------------------------
; запуск "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
World:          ; загрузка и запуск "мира"
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_WORLD, Page.World, Adr.World          ; принудительная установка места загрузки ресурса
                LOAD_EXE_ASSETS ASSETS_ID_WORLD                                 ; загрузка ресурса и запуск

                endif ; ~_MODULE_WORLD_EXECUTE_
