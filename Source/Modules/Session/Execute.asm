
                ifndef _MODULE_SESSION_EXECUTE_
                define _MODULE_SESSION_EXECUTE_
; -----------------------------------------
; запуск загрузки/инициализации сессии
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Session:        ; загрузка и запуск загрузки/инициализации сессии
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_EXE_ASSETS ASSETS_ID_SESSION                               ; загрузка ресурса и запуск
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_SESSION_EXECUTE_
