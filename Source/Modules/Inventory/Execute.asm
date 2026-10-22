
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
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_INVENTORY                            ; проверка перед запуском ресурса
                LOAD_OR_RESUME_ASSETS ASSETS_ID_INVENTORY, Inventory.Restore    ; загрузка или возобновление инвентаря
.Page           DB #00                                                          ; страница расположения загруженного FAssets

                endif ; ~_MODULE_INVENTORY_EXECUTE_
