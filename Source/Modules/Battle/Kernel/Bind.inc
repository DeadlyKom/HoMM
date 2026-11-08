
                ifndef _MODULE_BATTLE_KERNEL_BIND_
                define _MODULE_BATTLE_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                        ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL Battle.Initialize, Launch                        ; функция запуска (0)
                BIND_ID_KERNEL Battle.Restore, RestoreState                     ; возобновление работы битвы

                endif ; ~_MODULE_BATTLE_KERNEL_BIND_
