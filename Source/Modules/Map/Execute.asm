
                ifndef _MODULE_MAP_EXECUTE_
                define _MODULE_MAP_EXECUTE_
; -----------------------------------------
; загрузка карты
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Map.Load:       SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_MAP, Page.Map, Adr.Map
                EXE_ASSETS_NOT_PARAM ASSETS_ID_MAP, Map.Kernel.Load             ; загрузка ресурса и запуск

                endif ; ~_MODULE_MAP_EXECUTE_
