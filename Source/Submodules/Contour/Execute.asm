                ifndef _SUBMODULE_CONTOUR_EXECUTE_
                define _SUBMODULE_CONTOUR_EXECUTE_
; -----------------------------------------
; запуск сабмодуля "обводка"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Contour:        ; точка запуска сабмодуля "обводка"
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_SUBMODULE_CONTOUR                    ; проверка перед запуском ресурса
                LOAD_EXE_ASSETS ASSETS_ID_SUBMODULE_CONTOUR                     ; загрузка и запуск сабмодуля "обводка"
.Page           DB #00                                                          ; страница расположения загруженного FAssets

                endif ; ~_SUBMODULE_CONTOUR_EXECUTE_
