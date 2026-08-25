
                ifndef _CONST_OBJECT_DEFAULT_SETTINGS_
                define _CONST_OBJECT_DEFAULT_SETTINGS_
OBJECT_AFFILIATION_BIT      EQU 0x07                                            ; флаг, объект может принадлежать кому либо из игроков
                                                                                ;   0 - объект не может кому либо принадлежать
                                                                                ;   1 - объект может принадлежать кому либо
OBJECT_DEFAULT_PRE_TICK_BIT EQU OBJECT_PRE_TICK_BIT                             ; флаг, объект имеет функцию предварительного тика

OBJECT_NEUTRAL              EQU 0 << OBJECT_AFFILIATION_BIT
OBJECT_CAPTURED             EQU 1 << OBJECT_AFFILIATION_BIT
OBJECT_DEFAULT_PRE_TICK     EQU 1 << OBJECT_DEFAULT_PRE_TICK_BIT

                endif ; ~_CONST_OBJECT_DEFAULT_SETTINGS_
