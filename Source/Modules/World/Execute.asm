
                ifndef _MODULE_WORLD_EXECUTE_
                define _MODULE_WORLD_EXECUTE_
; -----------------------------------------
; запуск "мира"
; In:
;   HL - слот сохранения
; Out:
; Corrupt:
; Note:
; -----------------------------------------
World:          ; загрузка и запуск "мира"
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_EXE_ASSETS ASSETS_ID_WORLD                                 ; загрузка ресурса и запуск
.Release        SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                JP_RELEASE_ASSET ASSETS_ID_WORLD                                ; освобождение ресурса мира
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а
.MemoryAddress  DW #00                                                          ; адрес аллоцируемой памяти
                endif ; ~_MODULE_WORLD_EXECUTE_
