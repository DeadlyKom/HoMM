
                ifndef _VARIABLES_HARD_CONFIG_
                define _VARIABLES_HARD_CONFIG_
HardConfig      EQU Adr.HardConfig                                              ; адрес структуры конфигурации железа
.AvailablePages EQU HardConfig + FHardConfig.AvailablePages                     ; доступные страницы 16кб
.Input          EQU HardConfig + FHardConfig.Input                              ; флаги ограничения ввода

                endif ; ~_VARIABLES_HARD_CONFIG_
