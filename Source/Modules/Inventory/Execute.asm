
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
                SET_PAGE_ASSETS                                                 ; включить страницу расположения менеджера ресурсов
                LOAD_OR_RESUME_ASSETS ASSETS_ID_INVENTORY, Inventory.Restore    ; загрузка или возобновление инвентаря
.Page           DB #00                                                          ; страница расположения загруженного FAssets

                endif ; ~_MODULE_INVENTORY_EXECUTE_
