
                ifndef _KERNEL_EXECUTE_MODULE_
                define _KERNEL_EXECUTE_MODULE_
ExecuteModule
.Core               EQU Kernel.Modules.Core                                     ; запуск инициализации "ядра"
.Progress           EQU Kernel.Modules.Progress                                 ; запуск модуля "окна прогресса"
.MainMenu           EQU Kernel.Modules.MainMenu                                 ; запуск инициализации "главного меню"
.Session            EQU Kernel.Modules.Session                                  ; запуск загрузки/инициализации "сессии"
.World              EQU Kernel.Modules.World                                    ; запуск "мира"
.Combat             EQU Kernel.Modules.Combat                                   ; запуск "сражения"
.Characteristics    EQU Kernel.Modules.Characteristics                          ; запуск "характеристик"
.Inventory          EQU Kernel.Modules.Inventory                                ; запуск "инвентаря"
.Options            EQU Kernel.Modules.Options                                  ; запуск "опций"

                endif ; ~_KERNEL_EXECUTE_MODULE_
