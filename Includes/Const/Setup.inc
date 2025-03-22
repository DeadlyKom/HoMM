
                ifndef _CONST_SETUP_
                define _CONST_SETUP_
SELECT_PORT_1FFD_BIT    EQU 0x07                                                ; флага порта #1FFD выбран как дополнительный порт переключения страниц памяти
SELECT_PORT_7FFD_BIT    EQU 0x06                                                ; флага порта #7FFD выбран как порт переключения страниц памяти
SELECT_PORT_DFFD_BIT    EQU 0x05                                                ; флага порта #DFFD выбран как дополнительный порт переключения страниц памяти
SELECT_PORT_FDFD_BIT    EQU 0x04                                                ; флага порта #FDFD выбран как дополнительный порт переключения страниц памяти
SELECT_PORT_FFF7_BIT    EQU 0x03                                                ; флага порта #FFF7 выбран как дополнительный порт переключения страниц памяти
SELECT_PORT_EFF7_BIT    EQU 0x00                                                ; вспомогательный флаг, наличие порта #EFF7
SELECT_PORT_1FFD        EQU 1 << SELECT_PORT_1FFD_BIT
SELECT_PORT_7FFD        EQU 1 << SELECT_PORT_7FFD_BIT
SELECT_PORT_DFFD        EQU 1 << SELECT_PORT_DFFD_BIT
SELECT_PORT_FDFD        EQU 1 << SELECT_PORT_FDFD_BIT
SELECT_PORT_FFF7        EQU 1 << SELECT_PORT_FFF7_BIT
SELECT_PORT_EFF7        EQU 1 << SELECT_PORT_EFF7_BIT

                endif ; ~_CONST_SETUP_
