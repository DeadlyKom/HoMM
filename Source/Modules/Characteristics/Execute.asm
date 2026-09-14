
                ifndef _MODULE_CHARACTERISTICS_EXECUTE_
                define _MODULE_CHARACTERISTICS_EXECUTE_
; -----------------------------------------
; запуск модуля "характеристик"
; In:
; Out:
; Corrupt:
; Note:
;   пустышка, загрузка модуля пока отсутствует
; -----------------------------------------
Characteristics:; загрузка и запуск "главного меню"
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_EXE_ASSETS ASSETS_ID_CHARACTERISTICS                       ; загрузка ресурса и запуск
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_CHARACTERISTICS_EXECUTE_
