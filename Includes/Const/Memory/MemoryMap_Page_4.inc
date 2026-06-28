
                ifndef _CONST_MEMORY_MAP_PAGE_4_
                define _CONST_MEMORY_MAP_PAGE_4_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                            модуль Player | #1000 |
                ;   +-------+------------------------------------------+-------+
                ;   | #D000 |                                 свободно | #3000 |
                ;   +-------+------------------------------------------+-------+

                module Page
Page4           EQU PAGE_4
Music           EQU PAGE_4
                endmodule

                module Size
Code.Page4      EQU #1000                                                       ; размер модуля Player
Music.Slots     EQU #3000                                                       ; размер блока под музыку
                endmodule

                module Adr
Code.Page4      EQU #C000                                                       ; адрес модуля Player
Music.Slots     EQU #D000                                                       ; адрес блока под музыку
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_4_
