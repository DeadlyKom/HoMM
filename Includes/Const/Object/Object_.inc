
                ifndef _CONST_OBJECT_
                define _CONST_OBJECT_
OBJECT_SIZE                         EQU 32                                      ; размер структуры объекта FObject
OBJECT_DEFAULT_SIZE                 EQU 8                                       ; размер структуры объекта по умолчанию FObjectDefaultSettings
OBJECT_MAX                          EQU 128                                     ; максимальное количество объектов
OBJECT_DEFAULT_SETTINGS_MAX         EQU 128                                     ; максимальное количество настроек объектов по умолчанию
OBJECT_EMPTY_ELEMENT                EQU #FF                                     ; свободный элемент массива

; значения для поля FObject.Flags
; динамические флаги
OBJECT_DIRTY_BIT                    EQU 0x07                                    ; флаг, объект необходимо обновить
OBJECT_WEAKLY_REFERENCED_BIT        EQU 0x06                                    ; флаг, на объект существует слабая ссылка
OBJECT_CURSOR_HIT_STATE_BIT         EQU 0x05                                    ; флаг, курсор находится в bound объекта
OBJECT_PENDING_KILL_STATE_BIT       EQU 0x04                                    ; флаг, объект помечен на удаление

; статические флаги
OBJECT_TICK_ENABLED_BIT             EQU 0x03                                    ; флаг, разрешающий тик объекта
OBJECT_CURSOR_HIT_TEST_BIT          EQU 0x02                                    ; флаг, разрешающий проверку попадания курсора в bound объекта
OBJECT_SELF_CALCULATED_POSITION_BIT EQU 0x01                                    ; флаг, объект самостоятельно рассчитывает экранное положение

OBJECT_DIRTY                        EQU 1 << OBJECT_DIRTY_BIT
OBJECT_WEAKLY_REFERENCED            EQU 1 << OBJECT_WEAKLY_REFERENCED_BIT
OBJECT_CURSOR_HIT_STATE             EQU 1 << OBJECT_CURSOR_HIT_STATE_BIT
OBJECT_PENDING_KILL_STATE           EQU 1 << OBJECT_PENDING_KILL_STATE_BIT
OBJECT_TICK_ENABLED                 EQU 1 << OBJECT_TICK_ENABLED_BIT
OBJECT_CURSOR_HIT_TEST              EQU 1 << OBJECT_CURSOR_HIT_TEST_BIT
OBJECT_SELF_CALCULATED_POSITION     EQU 1 << OBJECT_SELF_CALCULATED_POSITION_BIT


                endif ; ~_CONST_OBJECT_INCLUDE_
