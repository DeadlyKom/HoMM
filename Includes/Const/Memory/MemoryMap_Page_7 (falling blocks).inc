
                ifndef _CONST_MEMORY_MAP_PAGE_7_FALLING_BLOCKS_
                define _CONST_MEMORY_MAP_PAGE_7_FALLING_BLOCKS_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                             ShadowScreen | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DB00 |                             FallingOrder | #00C0 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DBC0 |                           FallingStencil | #0018 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DBD8 |                                 свободно | #0028 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DC00 |                              FallingDist | #00C0 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DCC0 |                             FallingArray | #0040 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DD00 |                            FallingBuffer | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #F800 |                              FallingCode | #0800 |
                ;   +-------+------------------------------------------+-------+

                module Page
FallingBlocks   EQU PAGE_7

                endmodule

                module Size
FallingOrder    EQU #00C0                                                       ; размер массива номеров блоков, 192 байта
FallingDist     EQU #00C0                                                       ; размер массива расстояний, 192 байта
FallingStencil  EQU FallingOrder / 8                                            ; размер трафарета неподвижных блоков, 192 бита
FallingArray    EQU MAX_FALL_BLOCKS * FFallingBlock                             ; размер массива одновременно падающих блоков
FallingBlock    EQU #0024                                                       ; размер блока 16x16, 32 байта пикселей и 4 байта атрибутов
FallingBuffer   EQU FallingBlock * FallingOrder                                 ; размер буфера графики всех блоков, 6912 байт
FallingCode     EQU #10000 - Adr.FallingCode                                    ; доступный размер области кода эффекта
                endmodule

                module Adr
FallingOrder    EQU #DB00                                                       ; адрес массива номеров блоков
FallingDist     EQU #DC00                                                       ; адрес массива расстояний
FallingStencil  EQU #DBC0                                                       ; адрес трафарета, 1 обозначает неподвижный блок
FallingArray    EQU #DCC0                                                       ; адрес массива состояния падающих блоков
FallingBuffer   EQU #DD00                                                       ; адрес буфера графики всех блоков
FallingCode     EQU #F800                                                       ; адрес размещения кода эффекта
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_7_FALLING_BLOCKS_
