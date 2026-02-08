
                ifndef _CONST_MEMORY_MAP_PAGE_0_
                define _CONST_MEMORY_MAP_PAGE_0_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                             ObjectsArray | #1000 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D000 |                                HeroArray | #0400 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D400 |                         ParticipantArray | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D500 |                                 HeroPath | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D600 |                                 свободно | #1A00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                                     Code | #0A00 | ; блок кода
                ;   +-------+------------------------------------------+-------+
                ;   | #FA00 |                    ObjectDefaultSettings | #0400 | ; настройки объектов по умолчанию
                ;   +-------+------------------------------------------+-------+
                ;   | #FE00 |                       ChunkArrayCounters | #0100 | 
                ;   +-------+------------------------------------------+-------+
                ;   | #FF00 |                         ChunkArrayValues | #0100 |
                ;   +-------+------------------------------------------+-------+

                ; таблица быстрого формирования тумана (256 байт)
                ; таблица смещений быстрого рассчёта положения тайла (256 байт)

                module Page
Page0                   EQU PAGE_0
Object                  EQU PAGE_0
ObjectDefaultSettings   EQU PAGE_0
                endmodule

                module Size
ObjectsArray            EQU OBJECT_SIZE * OBJECT_MAX                            ; размер массива объектов
ParticipantArray        EQU #0100                                               ; размер массива участников (PARTICIPANT_SIZE * MAX_PARTICIPANT)
HeroPath                EQU #0100                                               ; размер массива найденого пути в виде последовательности координат тайлов (FPath),
                                                                                ; где нулевой элемент является последним
HeroArray               EQU HERO_SIZE * MAX_PARTICIPANT_HEROES * MAX_PARTICIPANT; размер массива героев
Code.Page0              EQU #0A00                                               ; размер блока кода
ObjectDefaultSettings   EQU OBJECT_DEFAULT_SIZE * OBJECT_DEFAULT_SETTINGS_MAX   ; размер таблицы настроек объектов по умолчанию
ChunkArrayCounters      EQU #0100                                               ; размер буфера чанков счётчиков
ChunkArrayValues        EQU #0100                                               ; размер буфера чанков ID объектов
                endmodule

                module Adr

ObjectsArray            EQU #C000                                               ; адрес массива объектов
HeroArray               EQU #D000                                               ; адрес массива героев
ParticipantArray        EQU #D400                                               ; адрес массива участников
HeroPath                EQU #D500                                               ; адрес массива найденого пути в виде последовательности координат тайлов (FPath),
                                                                                ; где нулевой элемент является последним
Code.Page0              EQU #F000                                               ; адрес блока кода
                                                                                ; (помещён в центр, при распоковке затрутся ObjectDefaultSettings)
ObjectDefaultSettings   EQU Adr.Code.Page0 + Size.Code.Page0                    ; адрес таблицы настроек объектов по умолчанию
                                                                                ; (помещён в центр, при распоковке затрутся StaticChunkArray)
ChunkArrayCounters      EQU Adr.ObjectDefaultSettings + Size.ObjectDefaultSettings ; адрес буфера чанков счётчиков
ChunkArrayValues        EQU Adr.ChunkArrayCounters + Size.ChunkArrayCounters    ; адрес буфера чанков ID объектов
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_0_
