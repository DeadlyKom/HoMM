
                ifndef _MODULE_COMBAT_EXECUTE_
                define _MODULE_COMBAT_EXECUTE_
; -----------------------------------------
; запуск модуля "сражения"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Combat:         ; загрузка или возобновление "сражения"
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_COMBAT                               ; проверка перед запуском ресурса
                LOAD_OR_RESUME_ASSETS ASSETS_ID_COMBAT, \
                    Combat.Restore                                              ; загрузка или возобновление "сражения"
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_COMBAT_EXECUTE_
