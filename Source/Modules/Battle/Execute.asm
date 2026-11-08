
                ifndef _MODULE_BATTLE_EXECUTE_
                define _MODULE_BATTLE_EXECUTE_
; -----------------------------------------
; запуск модуля "битвы"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Battle:         ; загрузка или возобновление "битвы"
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_BATTLE                               ; проверка перед запуском ресурса
                LOAD_OR_RESUME_ASSETS ASSETS_ID_BATTLE, \
                    Battle.Restore                                              ; загрузка или возобновление битвы
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_BATTLE_EXECUTE_
