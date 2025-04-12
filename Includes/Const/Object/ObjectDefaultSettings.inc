
                ifndef _CONST_OBJECT_DEFAULT_SETTINGS_
                define _CONST_OBJECT_DEFAULT_SETTINGS_
OBJECT_AFFILIATION_BIT  EQU 0x07                                                ; принадлежность
                                                                                ;   0 - объект не может кому либо принадлежать
                                                                                ;   1 - объект может принадлежать кому либо
OBJECT_NEUTRAL      EQU 0 << OBJECT_AFFILIATION_BIT
OBJECT_CAPTURED     EQU 1 << OBJECT_AFFILIATION_BIT

                endif ; ~_CONST_OBJECT_DEFAULT_SETTINGS_
