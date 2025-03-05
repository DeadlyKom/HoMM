
                ifndef _CONST_TR_DOS_
                define _CONST_TR_DOS_
ENABLE_IM2_BIT  EQU 0x00                                                        ; бит, включения прерывание IM2 по завершению работы с ПЗУ TR-DOS
ENABLE_IM2      EQU 1 << ENABLE_IM2_BIT                                         ; включить прерывание IM2 по завершению работы с ПЗУ TR-DOS
DISABLE_IM2     EQU 0 << ENABLE_IM2_BIT                                         ; выключить прерывание по завершению работы с ПЗУ TR-DOS

                endif ; ~_CONST_TR_DOS_


