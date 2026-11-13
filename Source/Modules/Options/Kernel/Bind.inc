
                ifndef _MODULE_OPTIONS_KERNEL_BIND_
                define _MODULE_OPTIONS_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                        ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL Options.Initialize, Launch                       ; функция запуска (0)
                BIND_ID_KERNEL Options.Restore, RestoreState                    ; возобновление работы "опций"

                endif ; ~_MODULE_OPTIONS_KERNEL_BIND_
