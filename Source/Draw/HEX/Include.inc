
                ifndef _DRAW_HEX_WORLD_INCLUDE_
                define _DRAW_HEX_WORLD_INCLUDE_

                module Hex
                
                include "World.asm"                                             ; (0)
                include "Column.asm"

                include "ColumnNew.asm"
                include "HexagonByDisplayList.asm"
                include "HexagonDisplayListGeneration.asm"
; TemplateSP      DS 2 * 4, 0
CallSequence    DS 15 * 2, 0    ; устарел!
DisplayList     ; -----------------------------------------
                ; представление дисплейного списка
                ; +0 - первая рисуемая колонка первого гексагона (0-6)
                ; +1 - индекс/смещение в рендер буфере обрабатываемого гексагона
                ; +2 - номер строки по вертикали в пикселях
                ; +3 - количество пропускаемых знакомест (спрайт находится ниже экрана)
                ; -----------------------------------------
                DS 8 * 4, 0
RowCounter      DB #00                                                          ; счётчик строк по вертикали в знакоместах (0-7)

                endmodule

                endif ; ~ _DRAW_HEX_WORLD_INCLUDE_
