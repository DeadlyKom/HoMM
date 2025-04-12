
                ifndef _CONST_MEMORY_MAP_PAGE_0_
                define _CONST_MEMORY_MAP_PAGE_0_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                              StaticArray | #0800 |
                ;   +-------+------------------------------------------+-------+
                ;   | #C800 |                             DynamicArray | #0800 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D000 |                                   FoWBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #E000 |                                 BiomeBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                                     Code | #0A00 | ; блок кода
                ;   +-------+------------------------------------------+-------+
                ;   | #FA00 |                    ObjectDefaultSettings | #0400 | ; настройки объектов по умолчанию
                ;   +-------+------------------------------------------+-------+
                ;   | #FE00 |                         StaticChunkArray | #0100 | 
                ;   +-------+------------------------------------------+-------+
                ;   | #FF00 |                        DynamicChunkArray | #0100 |
                ;   +-------+------------------------------------------+-------+

                ; таблица быстрого формирования тумана войны (256 байт)
                ; таблица смещений быстрого рассчёта положения тайла (256 байт)

                module Page
MapRaw                  EQU PAGE_0
BiomeBuf                EQU PAGE_0
ObjectDefaultSettings   EQU PAGE_0
Page0                   EQU PAGE_0
                endmodule

                module Size
StaticArray             EQU OBJECT_SIZE * OBJECT_MAX                            ; размер массива статических объектов
DynamicArray            EQU OBJECT_SIZE * OBJECT_MAX                            ; размер массива динамических объектов
FoWBuf                  EQU #1000                                               ; размер буфера тумана войны
BiomeBuf                EQU #1000                                               ; размер буфера биома (тайлов)
Code.Page0              EQU #0A00                                               ; размер блока кода
ObjectDefaultSettings   EQU OBJECT_DEFAULT_SIZE * OBJECT_DEFAULT_SETTINGS_MAX   ; размер таблицы настроек объектов по умолчанию
StaticChunkArray        EQU #0100                                               ; размер буфера чанков статических объектов
DynamicChunkArray       EQU #0100                                               ; размер буфера чанков динамических объектов
                endmodule

                module Adr

StaticArray             EQU #C000                                               ; адрес массива статических объектов
DynamicArray            EQU Adr.StaticArray + Size.StaticArray                  ; адрес массива динамических объектов
FoWBuf                  EQU Adr.DynamicArray + Size.DynamicArray                ; адрес буфера тумана войны
BiomeBuf                EQU Adr.FoWBuf + Size.FoWBuf                            ; адрес буфера биома (тайлов)
Code.Page0              EQU #F000                                               ; адрес блока кода
                                                                                ; (помещён в центр, при распоковке затрутся ObjectDefaultSettings)
ObjectDefaultSettings   EQU Adr.Code.Page0 + Size.Code.Page0                    ; адрес таблицы настроек объектов по умолчанию
                                                                                ; (помещён в центр, при распоковке затрутся StaticChunkArray)
StaticChunkArray        EQU Adr.ObjectDefaultSettings + Size.ObjectDefaultSettings ; адрес буфера чанков статических объектов
DynamicChunkArray       EQU Adr.StaticChunkArray + Size.StaticChunkArray        ; адрес буфера чанков динамических объектов
                                                                                ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_0_
