
                ifndef _MODULE_SESSION_EXECUTE_
                define _MODULE_SESSION_EXECUTE_
; -----------------------------------------
; запуск функции ассета сессии
; In:
;   A - идентификатор запускаемой функции
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Session:        PUSH AF                                                         ; сохранение индификатора запускаемой фцункции
                ; загрузка и запуск загрузки/инициализации сессии
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                JP_EXE_ASSET_FUNCTION ASSETS_ID_SESSION                         ; загрузка ресурса и запуск функции ассета
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_SESSION_EXECUTE_
