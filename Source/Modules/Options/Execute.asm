
                ifndef _MODULE_OPTIONS_EXECUTE_
                define _MODULE_OPTIONS_EXECUTE_
; -----------------------------------------
; запуск модуля "опций"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Options:        ; загрузка или возобновление "опций"
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_OPTIONS                              ; проверка перед запуском ресурса
                LOAD_OR_RESUME_ASSETS ASSETS_ID_OPTIONS, \
                    Options.Restore                                             ; загрузка или возобновление опций
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_OPTIONS_EXECUTE_
