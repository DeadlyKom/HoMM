                ifndef _DRAW_SPRITE_CONTOUR_HORIZONTAL_INCLUDE_
                define _DRAW_SPRITE_CONTOUR_HORIZONTAL_INCLUDE_

                module Horizontal
                include "Radius_1.asm"
                include "Radius_2.asm"
                include "Radius_3.asm"
Table:          ; таблицы выбора  функций по размеру спрайта по горизонтали
.Radius_1       DW Radius_1.Expand8, Radius_1.Expand16, Radius_1.Expand24, Radius_1.Expand32
.Radius_2       DW Radius_2.Expand8, Radius_2.Expand16, Radius_2.Expand24, Radius_2.Expand32
.Radius_3       DW Radius_3.Expand8, Radius_3.Expand16, Radius_3.Expand24, Radius_3.Expand32
                endmodule

                endif                                                           ; ~ _DRAW_SPRITE_CONTOUR_HORIZONTAL_INCLUDE_
