
                ifndef _MODULE_SESSION_KERNEL_BIND_
                define _MODULE_SESSION_KERNEL_BIND_
KERNEL_ID_COUNTER   defl 0                                                      ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL Session.Initialize, Launch                       ; функция запуска (0)

                ; функции, запрошенные вызывающим кодом
                BIND_ID_KERNEL Session.Make, Make_Session
                BIND_ID_KERNEL Session.Load, Load_Session

                endif ; ~_MODULE_SESSION_KERNEL_BIND_
