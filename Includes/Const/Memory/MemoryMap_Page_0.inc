
                ifndef _CONST_MEMORY_MAP_PAGE_0_
                define _CONST_MEMORY_MAP_PAGE_0_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                           BiomeRenderBuf | #0100 | ; ???
                ;   +-------+------------------------------------------+-------+
                ;   | #C100 |                          StaticRenderBuf | #0100 | ; ???
                ;   +-------+------------------------------------------+-------+
                ;   | #C200 |                         DynamicRenderBuf | #0100 | ; ???
                ;   +-------+------------------------------------------+-------+
                ;   | #C300 |                             FoWRenderBuf | #0100 | ; ???
                ;   +-------+------------------------------------------+-------+

                ;   +-------+------------------------------------------+-------+
                ;   | #0000 |                         StaticChunkArray | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #0000 |                        DynamicChunkArray | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #0000 |                              StaticArray | #0800 |
                ;   +-------+------------------------------------------+-------+
                ;   | #0000 |                             DynamicArray | #0800 | ; ToDo можно уменьшить размер структуры динамических объектов
                ;   +-------+------------------------------------------+-------+
                ;   | #E000 |                                 BiomeBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                                   FoWBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+

                ; таблица быстрого формирования тумана войны (256 байт)
                ; таблица смещений быстрого рассчёта положения тайла (256 байт)

                module Page
MapRaw          EQU PAGE_0
BiomeBuf        EQU PAGE_0
                endmodule

                module Size
FoWBuf          EQU #1000                                                       ; размер буфера тумана войны
BiomeBuf        EQU #1000                                                       ; размер буфера биома (тайлов)
                endmodule

                module Adr
MapRaw          EQU #C000                                                       ; адрес карты сырых данных
BiomeRenderBuf  EQU #C000                                                       ; адрес буфера рендер биома
StaticRenderBuf EQU #C100                                                       ; адрес буфера рендер статических объектов
DynamicRenderBuf EQU #C200                                                      ; адрес буфера рендер динамических объектов
FoWRenderBuf    EQU #C300                                                       ; адрес буфера рендер тумана войны
FoWBuf          EQU #E000                                                       ; адрес буфера тумана войны
BiomeBuf        EQU #F000                                                       ; адрес буфера биома (тайлов)
                                                                                ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_0_
