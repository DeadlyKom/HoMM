
                ifndef _CONST_OBJECT_DEFAULT_SETTINGS_UI_
                define _CONST_OBJECT_DEFAULT_SETTINGS_UI_
; типы объектов UI (ASSETS_ID_UI_GAMEPLAY_COMMON_PACK)
OBJECT_UI_COMMON_POINTER    EQU 0x00                                            ; указатель
OBJECT_UI_COMMON_FRAME_HERO EQU 0x01                                            ; рамка героя
OBJECT_UI_COMMON_SMALL_HERO EQU 0x02                                            ; маленький герой
OBJECT_UI_COMMON_STANDARD   EQU 0x03                                            ; штандарт

; значения для поля FODS_UI.Flags
OBJECT_UI_HOVER_BIT         EQU 0x07                                            ; флаг, UI поддерживает hover-поведение на объект привязки
OBJECT_UI_ATTR_ALIGN_BIT    EQU 0x00                                            ; флаг, инициализировать LAYER_OBJECT_ATTR_ALIGN

OBJECT_UI_HOVER             EQU 1 << OBJECT_UI_HOVER_BIT
OBJECT_UI_ATTR_ALIGN        EQU 1 << OBJECT_UI_ATTR_ALIGN_BIT

                endif ; ~_CONST_OBJECT_DEFAULT_SETTINGS_UI_
