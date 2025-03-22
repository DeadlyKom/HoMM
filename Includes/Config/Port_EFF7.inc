
                ifndef _CONFIG_ZX_SPECTRUM_PORT_EFF7_
                define _CONFIG_ZX_SPECTRUM_PORT_EFF7_
PORT_EFF7           EQU #EFF7                                                   ; порт управления ресурсами компьютера Pentagon 1024Кб
SET_RAM_To_ROM_BIT  EQU 0x3                                                     ; включает 0-ю страницу ОЗУ в область #0000..#3FFF
SET_RAM_To_ROM      EQU 1 << SET_RAM_To_ROM_BIT
                endif ; ~_CONFIG_ZX_SPECTRUM_PORT_EFF7_
