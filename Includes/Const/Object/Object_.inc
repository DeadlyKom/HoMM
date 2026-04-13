
                ifndef _CONST_OBJECT_
                define _CONST_OBJECT_
OBJECT_SIZE                         EQU 32                                      ; размер структуры объекта FObject
OBJECT_DEFAULT_SIZE                 EQU 8                                       ; размер структуры объекта по умолчанию FObjectDefaultSettings
OBJECT_MAX                          EQU 128                                     ; максимальное количество объектов
OBJECT_DEFAULT_SETTINGS_MAX         EQU 128                                     ; максимальное количество настроек объектов по умолчанию
OBJECT_EMPTY_ELEMENT                EQU #FF                                     ; свободный элемент массива

; значения для поля FObject.Flags
OBJECT_DIRTY_BIT                    EQU 0x05                                    ; флаг, объект необходимо обновить
OBJECT_EVALUATE_SIGNIF_BIT          EQU 0x04                                    ; флаг, обновления уровня значимости объекта
OBJECT_SIGNIFICANCE_LOCOMOTION_BIT  EQU 0x00                                    ; первый бит, двух байтного значения, значимости объекта
OBJECT_SIGNIFICANCE_AI_BIT          EQU 0x02                                    ; первый бит, двух байтного значения, значимости объекта
SIGNIFICANCE_LOCOMOTION_MASK        EQU %00000011
SIGNIFICANCE_LOCOMOTION_MASK_INV    EQU (~SIGNIFICANCE_LOCOMOTION_MASK) & 0xFF
SIGNIFICANCE_AI_MASK                EQU %00001100
SIGNIFICANCE_AI_MASK_INV            EQU (~SIGNIFICANCE_AI_MASK) & 0xFF

OBJECT_SIGNIFIC_MAXIMUM             EQU 0x00                                    ; максимальная, тикает каждое прерывание
OBJECT_SIGNIFIC_HIGH                EQU 0x01                                    ; высокая, каждое второе прерывание
OBJECT_SIGNIFIC_LOW                 EQU 0x02                                    ; низкая, тикает каждое четвёртое прерывание
OBJECT_SIGNIFIC_NONE                EQU 0x03                                    ; отсутствует, не тикает

OBJECT_DIRTY                        EQU 1 << OBJECT_DIRTY_BIT
OBJECT_EVALUATE_SIGNIF              EQU 1 << OBJECT_EVALUATE_SIGNIF_BIT

                endif ; ~_CONST_OBJECT_INCLUDE_
