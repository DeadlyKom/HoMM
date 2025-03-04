
                ifndef _MODULE_CORE_EXECUTE_
                define _MODULE_CORE_EXECUTE_
; -----------------------------------------
; запуск инициализации "ядра"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Core:           ; принудительная установка места загрузки ресурса
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_CORE, Page.Core, Adr.Core
                LOAD_EXE_ASSETS ASSETS_ID_CORE                                  ; загрузка ресурса и запуск

                endif ; ~_MODULE_CORE_EXECUTE_
