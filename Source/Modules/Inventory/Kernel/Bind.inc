
                ifndef _MODULE_INVENTORY_KERNEL_BIND_
                define _MODULE_INVENTORY_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                        ; счётчик идентификаторов

; идентификаторы функций
                BIND_ID_KERNEL Inventory.Initialize, Launch                     ; функция запуска (0)

                endif ; ~_MODULE_INVENTORY_KERNEL_BIND_
