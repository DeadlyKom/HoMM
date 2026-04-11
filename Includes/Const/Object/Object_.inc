
                ifndef _CONST_OBJECT_
                define _CONST_OBJECT_
OBJECT_SIZE                 EQU 32                                              ; размер структуры объекта FObject
OBJECT_DEFAULT_SIZE         EQU 8                                               ; размер структуры объекта по умолчанию FObjectDefaultSettings
OBJECT_MAX                  EQU 128                                             ; максимальное количество объектов
OBJECT_DEFAULT_SETTINGS_MAX EQU 128                                             ; максимальное количество настроек объектов по умолчанию
OBJECT_EMPTY_ELEMENT        EQU #FF                                             ; свободный элемент массива

; значения для поля FObject.Flags
OBJECT_SIGNIFICANCE_BIT     EQU 0x06                                            ; первый бит, двух байтного значения, значимости объекта
OBJECT_DIRTY_BIT            EQU 0x05                                            ; флаг, объект необходимо обновить
OBJECT_TICK_BIT             EQU 0x04                                            ; флаг, сигнализирующий о тиканье объекта

OBJECT_SIGNIFIC_MAXIMUM     EQU 0x00 << OBJECT_SIGNIFICANCE_BIT                 ; максимальная, тикает каждое прерывание
OBJECT_SIGNIFIC_HIGH        EQU 0x01 << OBJECT_SIGNIFICANCE_BIT                 ; высокая, каждое второе прерывание
OBJECT_SIGNIFIC_LOW         EQU 0x02 << OBJECT_SIGNIFICANCE_BIT                 ; низкая, тикает каждое четвёртое прерывание
OBJECT_SIGNIFIC_NONE        EQU 0x03 << OBJECT_SIGNIFICANCE_BIT                 ; отсутствует, не тикает

OBJECT_DIRTY                EQU 1 << OBJECT_DIRTY_BIT
OBJECT_TICK                 EQU 1 << OBJECT_TICK_BIT

                endif ; ~_CONST_OBJECT_INCLUDE_
