
                ifndef _MODULE_INVENTORY_EXECUTE_
                define _MODULE_INVENTORY_EXECUTE_
; -----------------------------------------
; запуск модуля "инвентаря"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Inventory:      ; точка запуска модуля "инвентаря"
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_EXE_ASSETS ASSETS_ID_INVENTORY                             ; загрузка ресурса и запуск
.Page           DB #00                                                          ; страница расположения загруженного FAssets

                endif ; ~_MODULE_INVENTORY_EXECUTE_
