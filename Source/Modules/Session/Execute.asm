
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
                JP_EXE_ASSET_FUNCTION_ONE_PARAM ASSETS_ID_SESSION               ; загрузка ресурса и запуск функции ассета
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_SESSION_EXECUTE_
