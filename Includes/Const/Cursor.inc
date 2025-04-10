
                ifndef _CONST_CURSOR_
                define _CONST_CURSOR_
CURSOR_LEFT_EDGE_BIT    EQU 0x07                                                ; флаг, границы по левому краю
CURSOR_RIGHT_EDGE_BIT   EQU 0x06                                                ; флаг, границы по правому краю
CURSOR_UP_EDGE_BIT      EQU 0x05                                                ; флаг, границы по верхнему краю
CURSOR_BOTTOM_EDGE_BIT  EQU 0x04                                                ; флаг, границы по нижнему краю
CURSOR_MIN_SPEED        EQU 3                                                   ; минимальная дефолтная скорость курсора
CURSOR_MAX_SPEED        EQU 24                                                  ; максимальная дефолтная скорость курсора
                endif ; ~_CONST_CURSOR_
