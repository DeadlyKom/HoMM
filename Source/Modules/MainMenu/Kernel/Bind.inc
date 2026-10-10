
                ifndef _MODULE_MAIN_MENU_KERNEL_BIND_
                define _MODULE_MAIN_MENU_KERNEL_BIND_
KERNEL_ID_COUNTER   defl 0                                                      ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL MainMenu.Initialize, Launch                      ; функция запуска (0)

                endif ; ~_MODULE_MAIN_MENU_KERNEL_BIND_
