
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex
                
                include "World.asm"                                             ; (0)
                include "Column.asm"
TemplateSP      DS 2 * 4, 0
CallSequence    DS 15 * 2, 0
VertCounter     DB #00                                                          ; счётчик строк по вертикали в знакоместах (0-7)

                if (CallSequence >> 8) - (($) >> 8)
                error "whole table must be within single 256 byte block"
                endif

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
