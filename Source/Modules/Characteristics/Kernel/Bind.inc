
                ifndef _MODULE_CHARACTERISTICS_KERNEL_BIND_
                define _MODULE_CHARACTERISTICS_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                         ; счётчик идентификаторов

; идентификаторы функций
                BIND_ID_KERNEL Characteristics.Initialize, Launch               ; функция запуска (0)

                endif ; ~_MODULE_CHARACTERISTICS_KERNEL_BIND_
