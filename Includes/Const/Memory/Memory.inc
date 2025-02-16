
                ifndef _CONST_MEMORY_
                define _CONST_MEMORY_
ScreenSize      EQU #1B00                                                       ; размер экрана
OneThirdScr     EQU #0800                                                       ; размер одной трети экрана
ImageSize       EQU #1800                                                       ; размер изображения
AttributeSize   EQU #0300                                                       ; размер атрибутов
BankSize        EQU #4000                                                       ; размер банка (16384 байт)

MemBank_01      EQU #4000                                                       ; Bank 01 (16384 байт)
MemBank_01_SCR  EQU MemBank_01                                                  ; Bank 01 (Screen 0)
MemBank_01_SCRA EQU MemBank_01 + ImageSize                                      ; Bank 01 (Screen 0) атрибуты
MemBank_01_     EQU MemBank_01_SCR + ScreenSize                                 ; Bank 01 пропуск экрана
MemBank_01_DOS  EQU MemBank_01_ + #0500                                         ; Bank 01 пропуск экрана и 0x500 байт данных для TR DOS)

MemBank_02      EQU #8000                                                       ; Bank 02 (16384 байт)

MemBank_03      EQU #C000                                                       ; Bank 03 (16384 байт)
MemBank_03_SCR  EQU MemBank_03                                                  ; Bank 03 (Screen 1)
MemBank_03_SCRA EQU MemBank_03_SCR + ImageSize                                  ; Bank 03 (Screen 1) атрибуты
MemBank_03_     EQU MemBank_03 + ScreenSize                                     ; Bank 03 пропуск экрана
                endif ; ~_CONST_MEMORY_
