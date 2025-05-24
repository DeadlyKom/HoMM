
                ifndef _CONST_INPUT_KEY_ID_
                define _CONST_INPUT_KEY_ID_
NUMBER_KEYS_ID      EQU 0x08
KEY_ID_NONE         EQU 0xFF                                                    ; отсутствует ID клавиши

KEY_ID_MENU         EQU 0x00                                                    ; клавиша "меню"
KEY_ID_ACCELERATION EQU 0x01                                                    ; клавиша "ускорить"
KEY_ID_ESC          EQU 0x02                                                    ; клавиша "выход"
KEY_ID_SELECT       EQU 0x03                                                    ; клавиша "выбор"
KEY_ID_RIGHT        EQU 0x04                                                    ; клавиша "вправо"
KEY_ID_LEFT         EQU 0x05                                                    ; клавиша "влево"
KEY_ID_DOWN         EQU 0x06                                                    ; клавиша "вниз"
KEY_ID_UP           EQU 0x07                                                    ; клавиша "вверх"

                endif ; ~_CONST_INPUT_KEY_ID_
