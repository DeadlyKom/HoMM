
                ifndef _MODULE_INVENTORY_KERNEL_BIND_
                define _MODULE_INVENTORY_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                        ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL Inventory.Initialize, Launch                     ; функция запуска (0)
                BIND_ID_KERNEL Inventory.Restore, RestoreState                  ; возобновление работы инвентаря

                endif ; ~_MODULE_INVENTORY_KERNEL_BIND_
