
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
                LOAD_EXE_ASSETS ASSETS_ID_WORLD                                 ; загрузка ресурса и запуск
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_WORLD_EXECUTE_
