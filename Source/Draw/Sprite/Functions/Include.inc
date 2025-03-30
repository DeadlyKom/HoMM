
                ifndef _DRAW_SPRITE_FUNCTIONS_INCLUDE_
                define _DRAW_SPRITE_FUNCTIONS_INCLUDE_

                module Function

                include "Shift_OR_XOR.asm"
                include "Shift_OR_XOR_Save.asm"
                include "NoShift_OR_XOR.asm"
                include "NoShift_OR_XOR_Save.asm"

                ; -----------------------------------------
                ; тип вывода спрайта
                ;   000 - OR & XOR с сохранением фона
                ;   001 - OR & XOR с сохранением фона    (зеркального отображения спрайта по горизонтали)
                ;   010 - OR & XOR
                ;   011 - OR & XOR                       (зеркального отображения спрайта по горизонтали)
                ;   100 - LD с атрибутами
                ;   101 - LD с атрибутами                (зеркального отображения спрайта по горизонтали)
                ;   110 - OR & XOR с атрибутами
                ;   111 - OR & XOR с атрибутами          (зеркального отображения спрайта по горизонтали)
                ; -----------------------------------------
Table:          
                ; таблица функций без сдвига (горизонталь, ширина спрайта в знакоместах)
.OR_XOR_SAVE_   DW OR_XOR_SAVE.NoShift.Table.OX_8,      OR_XOR_SAVE.NoShift.Table.OX_16,    OR_XOR_SAVE.NoShift.Table.OX_24,    #0000                           ; +
.M_OR_XOR_SAVE_ DW #0000,                               #0000,                              #0000,                              #0000                           ; -
.OR_XOR_        DW OR_XOR.NoShift.Table.OX_8,           OR_XOR.NoShift.Table.OX_16,         OR_XOR.NoShift.Table.OX_24,         OR_XOR.NoShift.Table.OX_32      ; +
.M_OR_XOR_      DW #0000, #0000, #0000, #0000       ; +
.LD_ATTR_       DW #0000, #0000, #0000, #0000       ; +
.M_LD_ATTR_     DW #0000,                               #0000,                              #0000,                              #0000                           ; -
.OR_XOR_ATTR_   DW #0000, #0000, #0000, #0000       ; +
.M_OR_XOR_ATTR_ DW #0000,                               #0000,                              #0000,                              #0000                           ; -
                ; таблица функций со сдвигом (горизонталь, ширина спрайта в знакоместах)
.OR_XOR_SAVE    DW OR_XOR_SAVE.Shift.Table.OX_8,        OR_XOR_SAVE.Shift.Table.OX_16,      OR_XOR_SAVE.Shift.Table.OX_24,      #0000                           ; +
.M_OR_XOR_SAVE  DW #0000,                               #0000,                              #0000,                              #0000                           ; -
.OR_XOR         DW OR_XOR.Shift.Table.OX_8,             OR_XOR.Shift.Table.OX_16,           OR_XOR.Shift.Table.OX_24,           OR_XOR.Shift.Table.OX_32        ; +
.M_OR_XOR       DW #0000, #0000, #0000, #0000       ; +
.LD_ATTR        DW #0000, #0000, #0000, #0000       ; +
.M_LD_ATTR      DW #0000,                               #0000,                              #0000,                              #0000                           ; -
.OR_XOR_ATTR    DW #0000, #0000, #0000, #0000       ; +
.M_OR_XOR_ATTR  DW #0000,                               #0000,                              #0000,                              #0000                           ; -

                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTIONS_INCLUDE_
