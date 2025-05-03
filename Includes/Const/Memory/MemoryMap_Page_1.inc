
                ifndef _CONST_MEMORY_MAP_PAGE_1_
                define _CONST_MEMORY_MAP_PAGE_1_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                                   FoWBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #D000 |                                 BiomeBuf | #1000 | ; примерно 64х64 по байту и 90х90 на 0.5 дайт на ID биома
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                                     Code | #0A00 | ; блок кода
                ;   +-------+------------------------------------------+-------+

                module Page
Page1           EQU PAGE_1
BiomeBuf        EQU PAGE_1
                endmodule

                module Size
FoWBuf          EQU #1000                                                       ; размер буфера тумана войны
BiomeBuf        EQU #1000                                                       ; размер буфера биома (тайлов)
Code.Page1      EQU #0A00                                                       ; размер блока кода
                endmodule

                module Adr
FoWBuf          EQU #C000                                                       ; адрес буфера тумана войны
BiomeBuf        EQU #D000                                                       ; адрес буфера биома (тайлов)
Code.Page1      EQU #F000                                                       ; адрес блока кода
                                                                                ; (помещён в центр, при распоковке затрутся ObjectDefaultSettings)
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_1_
