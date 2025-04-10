
                ifndef _CONST_OBJECT_DEFAULT_SETTINGS_
                define _CONST_OBJECT_DEFAULT_SETTINGS_
OBJECT_AFFILIATION_BIT  EQU 0x06                                                ; принадлежность
                                                                                ;   00 - объект не может кому либо принадлежать
                                                                                ;   10 - объект может принадлежать кому либо
                                                                                ;   11 - объект можно подобрать
OBJECT_NEUTRAL      EQU 0 << OBJECT_AFFILIATION_BIT
OBJECT_CAPTURED     EQU 2 << OBJECT_AFFILIATION_BIT
OBJECT_PICKUP       EQU 3 << OBJECT_AFFILIATION_BIT

                endif ; ~_CONST_OBJECT_DEFAULT_SETTINGS_
