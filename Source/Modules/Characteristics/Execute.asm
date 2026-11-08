
                ifndef _MODULE_CHARACTERISTICS_EXECUTE_
                define _MODULE_CHARACTERISTICS_EXECUTE_
; -----------------------------------------
; запуск модуля "характеристик"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Characteristics:; загрузка или возобновление "характеристик"
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_CHARACTERISTICS                      ; проверка перед запуском ресурса
                LOAD_OR_RESUME_ASSETS ASSETS_ID_CHARACTERISTICS, \
                    Characteristics.Restore                                     ; загрузка или возобновление характеристик
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_CHARACTERISTICS_EXECUTE_
