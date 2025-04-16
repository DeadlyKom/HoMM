
                ifndef _CONST_MEMORY_MAP_PAGE_0_
                define _CONST_MEMORY_MAP_PAGE_0_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                             ObjectsArray | #1000 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D000 |                                   FoWBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #E000 |                                 BiomeBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                                     Code | #0A00 | ; блок кода
                ;   +-------+------------------------------------------+-------+
                ;   | #FA00 |                    ObjectDefaultSettings | #0400 | ; настройки объектов по умолчанию
                ;   +-------+------------------------------------------+-------+
                ;   | #FE00 |                       ChunkArrayCounters | #0100 | 
                ;   +-------+------------------------------------------+-------+
                ;   | #FF00 |                         ChunkArrayValues | #0100 |
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
ObjectsArray             EQU OBJECT_SIZE * OBJECT_MAX                           ; размер массива объектов
FoWBuf                  EQU #1000                                               ; размер буфера тумана войны
BiomeBuf                EQU #1000                                               ; размер буфера биома (тайлов)
Code.Page0              EQU #0A00                                               ; размер блока кода
ObjectDefaultSettings   EQU OBJECT_DEFAULT_SIZE * OBJECT_DEFAULT_SETTINGS_MAX   ; размер таблицы настроек объектов по умолчанию
ChunkArrayCounters      EQU #0100                                               ; размер буфера чанков счётчиков
ChunkArrayValues        EQU #0100                                               ; размер буфера чанков ID объектов
                endmodule

                module Adr

ObjectsArray            EQU #C000                                               ; адрес массива объектов
FoWBuf                  EQU Adr.ObjectsArray + Size.ObjectsArray                ; адрес буфера тумана войны
BiomeBuf                EQU Adr.FoWBuf + Size.FoWBuf                            ; адрес буфера биома (тайлов)
Code.Page0              EQU #F000                                               ; адрес блока кода
                                                                                ; (помещён в центр, при распоковке затрутся ObjectDefaultSettings)
ObjectDefaultSettings   EQU Adr.Code.Page0 + Size.Code.Page0                    ; адрес таблицы настроек объектов по умолчанию
                                                                                ; (помещён в центр, при распоковке затрутся StaticChunkArray)
ChunkArrayCounters      EQU Adr.ObjectDefaultSettings + Size.ObjectDefaultSettings ; адрес буфера чанков счётчиков
ChunkArrayValues        EQU Adr.ChunkArrayCounters + Size.ChunkArrayCounters    ; адрес буфера чанков ID объектов
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_0_
