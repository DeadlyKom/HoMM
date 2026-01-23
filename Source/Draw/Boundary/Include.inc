
                ifndef _DRAW_BOUNDARY_SPRITE_INCLUDE_
                define _DRAW_BOUNDARY_SPRITE_INCLUDE_

                module Boundary

                include "DrawNotClipping.asm"
                include "Functions/Include.inc"
FunctionTable:  ; тип вывода спрайта
                DW Functions.LD_ATTR                                            ; 00 (обычный вывод)
                DW Functions.LD_ATTR_HM                                         ; 01 (зеркального отображения спрайта по горизонтали)
                DW Functions.LD_ATTR_VM                                         ; 10 (зеркального отображения спрайта по вертикали)
                DW Functions.LD_ATTR_HVM                                        ; 11 (зеркального отображения спрайта по вертикали и горизонтали)

                DW Functions.OR_XOR_ATTR                                        ; 00 (обычный вывод)
                DW Functions.OR_XOR_ATTR_HM                                     ; 01 (зеркального отображения спрайта по горизонтали)
                DW Functions.OR_XOR_ATTR_VM                                     ; 10 (зеркального отображения спрайта по вертикали)
                DW Functions.OR_XOR_ATTR_HVM                                    ; 11 (зеркального отображения спрайта по вертикали и горизонтали)

                endmodule

                endif ; ~ _DRAW_BOUNDARY_SPRITE_INCLUDE_
