
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex
                
                include "World.asm"                                             ; (0)
                include "Row.asm"                                               ; (1)
                include "Column.asm"                                            ; (2)

HorizontalTable ;
                dup 4
                DB 0 * 2
                DB 1 * 2
                DB 2 * 2
                DB 3 * 2
                DB 4 * 2
                DB 5 * 2
                edup
                DB 0 * 2
                DB 1 * 2
                DB 2 * 2
.End            EQU $

CallSequence    ;
                DW Column.x2, Column.x6, Column.x8, Column.x8, Column.x6, Column.x2, Row.Sequent
.Copy           DS 7 * 2, 0

                if (HorizontalTable >> 8) - (($) >> 8)
                error "whole table must be within single 256 byte block"
                endif

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
