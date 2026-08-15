
                ifndef _CONST_OBJECT_DEFAULT_SETTINGS_CHARACTER_
                define _CONST_OBJECT_DEFAULT_SETTINGS_CHARACTER_
; значения для поля FODS_Character.Flags
OBJECT_CHARACTER_SPAWN_UI_ON_HOVER_BIT         EQU 0x07                         ; флаг, при наведении на персонажа спавнится UI объект

OBJECT_CHARACTER_SPAWN_UI_ON_HOVER             EQU 1 << OBJECT_CHARACTER_SPAWN_UI_ON_HOVER_BIT

                endif ; ~_CONST_OBJECT_DEFAULT_SETTINGS_CHARACTER_
