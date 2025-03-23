
                ifndef _DRAW_SPRITE_FUNCTIONS_INCLUDE_
                define _DRAW_SPRITE_FUNCTIONS_INCLUDE_

                module Function

                include "Shift_OR_XOR.asm"
                include "NoShift_OR_XOR.asm"
Table:          ; таблица функций со сдвигом (горизонталь, ширина спрайта в знакоместах)
.LD             DW #0000, #0000, #0000, #0000       ; +
.M_LD           DW #0000, #0000, #0000, #0000       ; -
.OR_XOR         DW OR_XOR.Shift.Table.OX_8,         OR_XOR.Shift.Table.OX_16,       OR_XOR.Shift.Table.OX_24,       OR_XOR.Shift.Table.OX_32         ; +
.M_OR_XOR       DW #0000, #0000, #0000, #0000       ; +
.LD_ATTR        DW #0000, #0000, #0000, #0000       ; +
.M_LD_ATTR      DW #0000, #0000, #0000, #0000       ; -
.OR_XOR_ATTR    DW #0000, #0000, #0000, #0000       ; +
.M_OR_XOR_ATTR  DW #0000, #0000, #0000, #0000       ; -
                ; таблица функций без сдвига (горизонталь, ширина спрайта в знакоместах)
.LD_            DW #0000, #0000, #0000, #0000       ; +
.M_LD_          DW #0000, #0000, #0000, #0000       ; -
.OR_XOR_        DW OR_XOR.NoShift.Table.OX_8,       OR_XOR.NoShift.Table.OX_16,     OR_XOR.NoShift.Table.OX_24,      OR_XOR.NoShift.Table.OX_32       ; +
.M_OR_XOR_      DW #0000, #0000, #0000, #0000       ; +
.LD_ATTR_       DW #0000, #0000, #0000, #0000       ; +
.M_LD_ATTR_     DW #0000, #0000, #0000, #0000       ; -
.OR_XOR_ATTR_   DW #0000, #0000, #0000, #0000       ; +
.M_OR_XOR_ATTR_ DW #0000, #0000, #0000, #0000       ; -

                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTIONS_INCLUDE_
