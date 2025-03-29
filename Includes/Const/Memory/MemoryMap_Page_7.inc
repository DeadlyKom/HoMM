
                ifndef _CONST_MEMORY_MAP_PAGE_7_
                define _CONST_MEMORY_MAP_PAGE_7_
                
                ;   +-------+------------------------------------------+-------+
                ;   | #С000 |                            Shadow Screen | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DB00 |                          ArrayAdrTileSpr | #0100 | ; для хранения адресов 128 тайлопар нужно 256 байт
                ;   +-------+------------------------------------------+-------+
                ;   | #DC00 |                          TileSpritesAttr | #1200 |
                ;   +-------+------------------------------------------+-------+
                ;   | #EE00 |                     буфер для распаковки | #0100 | ; мб следует хранить данные на диске без сжатия (непотребуется буфер)
                ;   +-------+------------------------------------------+-------+
                ;   | #EF00 |                                          | #0000 |
                ;   +-------+------------------------------------------+-------+

                module Page
TileSprites     EQU PAGE_7
                endmodule

                module Size
ArrayAdrTileSpr EQU #0100                                                       ; размер массива адресов спрайтов тайлов (128 тайлов * 2 байта)
TileSpritesAttr EQU #1200                                                       ; размер спрайтов тайлов (128 тайлов * 36 байт)
TempBuffer      EQU #0100                                                       ; размер буфер для распаковки
                endmodule

                module Adr
TileSprites     EQU #DB00
ArrayAdrTileSpr EQU TileSprites                                                 ; адрес массива адресов спрайтов тайлов
TileSpritesAttr EQU ArrayAdrTileSpr + Size.ArrayAdrTileSpr                      ; адрес спрайты тайлов
TempBuffer      EQU #EE00                                                       ; буфер для распаковки
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_7_
