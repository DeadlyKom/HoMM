
                ifndef _STRUCT_OBJECT_DEFAULT_SETTINGS_CHARACTER_
                define _STRUCT_OBJECT_DEFAULT_SETTINGS_CHARACTER_

                struct FODS_Character                                           ; настройки объекта по умолчанию - персонаж                 [8 байт]
Super           FObjectDefaultSettings                                          ; базовые настройки                                         [4 байта]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | HS | .. | .. | .. | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   HS      [7]     - флаг, объект при пересечении с курсором спавнит UI объект
;                     тип UI объекта хранится в переменной A
; -----------------------------------------
Flags           DB #00                                                          ; флаги                                                     [1 байт]

Dummy           DS 3, 0                                                         ; резерв                                                    [3 байт]
                ends

                endif ; ~_STRUCT_OBJECT_DEFAULT_SETTINGS_CHARACTER_
