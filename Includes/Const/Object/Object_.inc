
                ifndef _CONST_OBJECT_
                define _CONST_OBJECT_
OBJECT_SIZE                 EQU 16                                              ; размер структуры объекта FObject
OBJECT_DEFAULT_SIZE         EQU 8                                               ; размер структуры объекта по умолчанию FObjectDefaultSettings
OBJECT_MAX                  EQU 256                                             ; максимальное количество объектов
OBJECT_DEFAULT_SETTINGS_MAX EQU 128                                             ; максимальное количество настроек объектов по умолчанию
OBJECT_EMPTY_ELEMENT        EQU #FF                                             ; свободный элемент массива

                endif ; ~_CONST_OBJECT_INCLUDE_
