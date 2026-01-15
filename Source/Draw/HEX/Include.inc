
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex

                include "Column.asm"
                include "HexagonByDisplayList.asm"
                include "HexagonDisplayListGeneration.asm"
CallSequence    DS 15 * 2, 0                                                    ; 14 вложений + 1 (дополнительный)
DisplayList     ; -----------------------------------------
                ; представление дисплейного списка
                ; +0 - первая рисуемая колонка первого гексагона (0-5)
                ; +1 - индекс/смещение в рендер буфере обрабатываемого гексагона
                ; +2 - индекс/смещение в рендер буфере обрабатываемого гексагона +80
                ; +3 - номер строки по вертикали в пикселях
                ; +4 - количество пропускаемых знакомест (спрайт находится ниже экрана)
                ; -----------------------------------------
.ElementSize    EQU 5
                DS 8 * .ElementSize, 0
.Size           EQU $-DisplayList

                if (DisplayList >> 8) - ($ >> 8)
                error "whole table must be within single 256 byte block"
                endif

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
