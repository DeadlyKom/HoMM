
                ifndef _CONST_OBJECT_DEFAULT_SETTINGS_UI_
                define _CONST_OBJECT_DEFAULT_SETTINGS_UI_
; значения для поля FODS_UI.Flags
OBJECT_UI_HOVER_BIT         EQU 0x07                                            ; флаг, UI поддерживает hover-поведение на объект привязки

OBJECT_UI_HOVER             EQU 1 << OBJECT_UI_HOVER_BIT

                endif ; ~_CONST_OBJECT_DEFAULT_SETTINGS_UI_
