
                ifndef _MODULE_SESSION_EXECUTE_
                define _MODULE_SESSION_EXECUTE_
; -----------------------------------------
; запуск функции ресурса сессии
; In:
;   A - идентификатор запускаемой функции
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Session:        PUSH AF                                                         ; сохранение идентификатора запускаемой функции
                JP_EXE_ASSET_FUNCTION_ONE_PARAM ASSETS_ID_SESSION               ; загрузка ресурса и запуск функции ресурса
.Page           DB #00                                                          ; страница загруженного ресурса Session

                endif ; ~_MODULE_SESSION_EXECUTE_
