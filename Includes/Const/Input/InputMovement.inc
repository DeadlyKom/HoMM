
                ifndef _CONST_INPUT_MOVEMENT_
                define _CONST_INPUT_MOVEMENT_
LEFT_MOUSE_KEY_BIT      EQU 0x07                                                ; флаг, нажатия левой клавиши мыши
RIGHT_MOUSE_KEY_BIT     EQU 0x06                                                ; флаг, нажатия правой клавиши мыши
ACCELERATE_CURSOR_BIT   EQU 0x04                                                ; флаг, нажата клавиша ускорения курсора
MOVEMENT_LEFT_BIT       EQU 0x03                                                ; флаг, нажатия клавиши влево
MOVEMENT_RIGHT_BIT      EQU 0x02                                                ; флаг, нажатия клавиши вправо
MOVEMENT_UP_BIT         EQU 0x01                                                ; флаг, нажатия клавиши вверх
MOVEMENT_DOWN_BIT       EQU 0x00                                                ; флаг, нажатия клавиши вниз
MOVEMENT_MASK           EQU 1 << MOVEMENT_LEFT_BIT | 1 << MOVEMENT_RIGHT_BIT | \
                            1 << MOVEMENT_UP_BIT   | 1 << MOVEMENT_DOWN_BIT
LEFT_MOUSE_KEY          EQU 1 << LEFT_MOUSE_KEY_BIT
RIGHT_MOUSE_KEY         EQU 1 << RIGHT_MOUSE_KEY_BIT

                endif ; ~_CONST_INPUT_MOVEMENT_
