
                ifndef _CONST_INPUT_ENTER_
                define _CONST_INPUT_ENTER_

; флаги работы с вводом
INPUT_CAPS_SHIFT_BIT        EQU 0x00                                            ; флаг, зажат Caps Shift
INPUT_SYMBOL_SHIFT_BIT      EQU 0x01                                            ; флаг, зажат Symbol Shift
INPUT_SCAN_DISABLE_BIT      EQU 0x04                                            ; флаг, отключения сканирывания ввода
INPUT_PRESSED_BIT           EQU 0x05                                            ; флаг, нажатия клавиши
INPUT_NOT_PROCESSED_BIT     EQU 0x06                                            ; флаг, отсутствия действия нажати/отпускания клавиши
INPUT_MODE_TEXT_BIT         EQU 0x07                                            ; флаг, режим ввода текста

INPUT_CAPS_SHIFT            EQU 1 << INPUT_CAPS_SHIFT_BIT
INPUT_SYMBOL_SHIFT          EQU 1 << INPUT_SYMBOL_SHIFT_BIT
INPUT_NOT_PROCESSED         EQU 1 << INPUT_NOT_PROCESSED_BIT
INPUT_MODE_TEXT             EQU 1 << INPUT_MODE_TEXT_BIT

                endif ; ~_CONST_INPUT_ENTER_
