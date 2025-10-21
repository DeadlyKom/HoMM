
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex
                
                include "World.asm"                                             ; (0)
                include "Row.asm"                                               ; (1)
                include "Column.asm"                                            ; (2)

HorizontalTable ;
                dup 4
                DB 0
                DW Column.x2
                DB 1
                DW Column.x6
                DB 2
                DW Column.x8
                DB 3
                DW Column.x8
                DB 4
                DW Column.x6
                DB 5
                DW Column.x2
                edup
                DB 0
                DW Column.x2
                DB 1
                DW Column.x6
                DB 2
                DW Column.x8
.End            EQU $

CallSequence    DW Column.x2, Column.x4, Column.x8, Column.x8, Column.x4, Column.x2, Row.NextHexagon

                RET

                if (HorizontalTable >> 8) - ((HorizontalTable.End) >> 8)
                error "whole table must be within single 256 byte block"
                endif

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
