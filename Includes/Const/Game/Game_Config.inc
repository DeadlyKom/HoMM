
                ifndef _CONST_GAME_CONFIG_FLAGS_
                define _CONST_GAME_CONFIG_FLAGS_
INPUT_KEYBOARD          EQU 0x00                                                ; тип ввода - клавиатура
INPUT_REDEFINE_KEYS     EQU 0x01                                                ; тип ввода - переопределение клавиш
INPUT_KEMPSTON_5        EQU 0x02                                                ; тип ввода - кемпстон джойстик 5 кнопок
INPUT_KEMPSTON_8        EQU 0x03                                                ; тип ввода - кемпстон джойстик 8 кнопок
INPUT_MASK              EQU %00000011
INPUT_MASK_INV          EQU (~INPUT_MASK) & 0xFF

CONFIG_LANGUAGE_MASK    EQU %00000100                                           ; тип языка

; флаги игровых настроек
O_AUTOSAVE_BIT          EQU 0x03                                                ; бит вкл/выкл автосейва

                endif ; ~_CONST_GAME_CONFIG_FLAGS_
