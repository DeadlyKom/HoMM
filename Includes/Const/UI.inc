
                ifndef _CONST_UI_
                define _CONST_UI_
LAYER_UI_VISIBLE_BIT    EQU 0x00                                                ; флаг, слой видимый
UI_VISIBLE_BIT          EQU 0x00                                                ; флаг, элемент видимый
UI_ENABLED_BIT          EQU 0x01                                                ; флаг, элемент доступен для взаимодействия
LAYER_UI_VISIBLE        EQU 1 << LAYER_UI_VISIBLE_BIT
UI_VISIBLE              EQU 1 << UI_VISIBLE_BIT
UI_ENABLED              EQU 1 << UI_ENABLED_BIT
UI_TOOLTIP_HOVER_DELAY  EQU 0x10                                                ; задержка при наведении курсора на всплывающую подсказку пользовательского интерфейса

                endif ; ~_CONST_UI_
