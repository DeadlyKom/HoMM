
                ifndef _CONST_INPUT_MOVEMENT_
                define _CONST_INPUT_MOVEMENT_
MENU_KEY_BIT            EQU 0x07                                                ; флаг, нажатия клавиши "меню/пауза"
ESC_KEY_BIT             EQU 0x06                                                ; флаг, нажатия клавиши "выход"
SELECT_KEY_BIT          EQU 0x05                                                ; флаг, нажатия клавиши "выбор"
ACCELERATE_CURSOR_BIT   EQU 0x04                                                ; флаг, нажата клавиша ускорения курсора
MOVEMENT_LEFT_BIT       EQU 0x03                                                ; флаг, нажатия клавиши влево
MOVEMENT_RIGHT_BIT      EQU 0x02                                                ; флаг, нажатия клавиши вправо
MOVEMENT_UP_BIT         EQU 0x01                                                ; флаг, нажатия клавиши вверх
MOVEMENT_DOWN_BIT       EQU 0x00                                                ; флаг, нажатия клавиши вниз
MOVEMENT_MASK           EQU 1 << MOVEMENT_LEFT_BIT | 1 << MOVEMENT_RIGHT_BIT | \
                            1 << MOVEMENT_UP_BIT   | 1 << MOVEMENT_DOWN_BIT

                endif ; ~_CONST_INPUT_MOVEMENT_
