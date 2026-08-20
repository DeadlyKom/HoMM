
                ifndef _STRUCT_OBJECT_DEFAULT_SETTINGS_UI_
                define _STRUCT_OBJECT_DEFAULT_SETTINGS_UI_

                struct FODS_UI                                                  ; настройки объекта по умолчанию - UI                       [8 байт]
Super           FObjectDefaultSettings                                          ; базовые настройки                                         [4 байта]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | HV | .. | .. | .. | .. | .. | .. | AA |
;   +----+----+----+----+----+----+----+----+
;
;   HV      [7]     - флаг, UI поддерживает hover-поведение на объект привязки
;                     время, на которое обновляется Lifetime объекта,
;                     хранится в переменной A (1/25 секунды)
;   AA      [0]     - флаг, инициализировать LAYER_OBJECT_ATTR_ALIGN
; -----------------------------------------
Flags           DB #00                                                          ; флаги                                                     [1 байт]

Offset          FVector8                                                        ; смещение UI объекта относительно объекта привязки         [2 байта]
Behavior        DB #00                                                          ; поведение UI объекта                                      [1 байт]
                ends

                endif ; ~_STRUCT_OBJECT_DEFAULT_SETTINGS_UI_
