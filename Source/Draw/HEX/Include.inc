
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex

                include "Column.asm"
                include "HexagonByDisplayList.asm"
                include "HexagonDisplayListGeneration.asm"
; CallSequence    DS 15 * 2, 0                                                    ; 14 вложений + 1 (дополнительный)

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
