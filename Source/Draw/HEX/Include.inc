
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex
                
                include "World.asm"                                             ; (0)
                include "Column.asm"
TemplateSP      DS 2 * 4, 0
CallSequence    DS 15 * 2, 0
RowCounter      DB #00                                                          ; счётчик строк по вертикали в знакоместах (0-7)

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
