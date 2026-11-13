
                ifndef _MODULE_COMBAT_KERNEL_BIND_
                define _MODULE_COMBAT_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                        ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL Combat.Initialize, Launch                        ; функция запуска (0)
                BIND_ID_KERNEL Combat.Restore, RestoreState                     ; возобновление работы "сражения"

                endif ; ~_MODULE_COMBAT_KERNEL_BIND_
