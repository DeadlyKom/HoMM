
                ifndef _MODULE_MAIN_MENU_EXECUTE_
                define _MODULE_MAIN_MENU_EXECUTE_
; -----------------------------------------
; запуск "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
MainMenu:       ; загрузка и запуск "главного меню"
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_EXE_ASSETS ASSETS_ID_MAIN_MENU                             ; загрузка ресурса и запуск
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_MAIN_MENU_EXECUTE_
