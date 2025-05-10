
                ifndef _KERNEL_EXECUTE_MODULE_
                define _KERNEL_EXECUTE_MODULE_
ExecuteModule
.Core           EQU Kernel.Modules.Core                                         ; запуск инициализации "ядра"
.MainMenu       EQU Kernel.Modules.MainMenu                                     ; запуск инициализации "главного меню"
.Session        EQU Kernel.Modules.Session                                      ; запуск загрузки/инициализации сессии
.World          EQU Kernel.Modules.World                                        ; запуск "мира"

                endif ; ~_KERNEL_EXECUTE_MODULE_
