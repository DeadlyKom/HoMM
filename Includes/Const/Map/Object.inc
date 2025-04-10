
                ifndef _CONST_MAP_OBJECT_
                define _CONST_MAP_OBJECT_
MAP_OBJECT_TYPE_BIT EQU 0x00                                                    ; флаг, типа объекта
                                                                                ;   0 - статический
                                                                                ;   1 - динамический

MAP_OBJECT_STATIC   EQU 0 << MAP_OBJECT_TYPE_BIT
MAP_OBJECT_DYNAMIC  EQU 1 << MAP_OBJECT_TYPE_BIT
                endif ; ~_CONST_MAP_OBJECT_
