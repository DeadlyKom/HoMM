
                ifndef _GRAPHICS_UI_SLOTS_PACK_
                define _GRAPHICS_UI_SLOTS_PACK_

                module Slots
Slot_1x1:       DB .Num
.Parts          SPRITE 18, 17,      -1,    -1, OR_XOR, 0, Slot._1x1
.Num            EQU ($-.Parts) / FSprite
Slot_2x1:       DB .Num
.Parts          SPRITE  8,  8,       0,     0, OR_XOR, 0, Slot.LeftTop
                SPRITE  8,  3,     0+8,     0, OR_XOR, 0, Slot.Top
                SPRITE  8,  3,    0+16,     0, OR_XOR, 0, Slot.Top
                SPRITE  8,  8,    0+24,     0, OR_XOR, 0, Slot.RightTopJoin
                SPRITE  8,  8,      -1,   0+8, OR_XOR, 0, Slot.LeftBottomJoin
                SPRITE  8,  4,    -1+8,   4+8, OR_XOR, 0, Slot.Bottom
                SPRITE  8,  4,   -1+16,   4+8, OR_XOR, 0, Slot.Bottom
                SPRITE  8,  8,   -1+24,   0+8, OR_XOR, 0, Slot.RightBottom
.Num            EQU ($-.Parts) / FSprite
Slot_2x2:       DB .Num
.Parts          SPRITE  8,  8,       0,     0, OR_XOR, 0, Slot.LeftTop
                SPRITE  8,  3,     0+8,     0, OR_XOR, 0, Slot.Top
                SPRITE  8,  3,    0+16,     0, OR_XOR, 0, Slot.Top
                SPRITE  8,  8,    0+24,     0, OR_XOR, 0, Slot.RightTop
                SPRITE  4,  8,       0,   0+8, OR_XOR, 0, Slot.Left
                SPRITE  4,  8,    4+24,   0+8, OR_XOR, 0, Slot.RightJoin
                SPRITE  5,  8,      -1,  0+16, OR_XOR, 0, Slot.LeftJoin
                SPRITE  3,  8, -1+5+24,  0+16, OR_XOR, 0, Slot.Right
                SPRITE  8,  8,      -1,  0+24, OR_XOR, 0, Slot.LeftBottom
                SPRITE  8,  4,    -1+8,  4+24, OR_XOR, 0, Slot.Bottom
                SPRITE  8,  4,   -1+16,  4+24, OR_XOR, 0, Slot.Bottom
                SPRITE  8,  8,   -1+24,  0+24, OR_XOR, 0, Slot.RightBottom
.Num            EQU ($-.Parts) / FSprite
Slot_2x3:       DB .Num
.Parts          SPRITE  8,  8,       0,     0, OR_XOR, 0, Slot.LeftTop
                SPRITE  8,  3,     0+8,     0, OR_XOR, 0, Slot.Top
                SPRITE  8,  3,    0+16,     0, OR_XOR, 0, Slot.Top
                SPRITE  8,  8,    0+24,     0, OR_XOR, 0, Slot.RightTop
                SPRITE  4,  8,       0,   0+8, OR_XOR, 0, Slot.Left
                SPRITE  4,  8,    4+24,   0+8, OR_XOR, 0, Slot.RightJoin
                SPRITE  4,  8,       0,  0+16, OR_XOR, 0, Slot.Left
                SPRITE  4,  8,    4+24,  0+16, OR_XOR, 0, Slot.RightJoin
                SPRITE  5,  8,      -1,  0+24, OR_XOR, 0, Slot.LeftJoin
                SPRITE  3,  8, -1+5+24,  0+24, OR_XOR, 0, Slot.Right
                SPRITE  4,  8,      -1,  0+32, OR_XOR, 0, Slot.Left
                SPRITE  4,  8, -1+4+24,  0+32, OR_XOR, 0, Slot.Right
                SPRITE  8,  8,      -1,  0+40, OR_XOR, 0, Slot.LeftBottom
                SPRITE  8,  4,    -1+8,  4+40, OR_XOR, 0, Slot.Bottom
                SPRITE  8,  4,   -1+16,  4+40, OR_XOR, 0, Slot.Bottom
                SPRITE  8,  8,   -1+24,  0+40, OR_XOR, 0, Slot.RightBottom
.Num            EQU ($-.Parts) / FSprite
Slot:           ; спрайты частей слотов
._1x1           incbin "slot_1x1_mask.bin"
.Top            incbin "slot_top_mask.bin"
.Bottom         incbin "slot_bottom_mask.bin"
.Left           incbin "slot_left_mask.bin"
.LeftJoin       incbin "slot_left_join_mask.bin"
.LeftBottom     incbin "slot_left_bottom_mask.bin"
.LeftBottomJoin incbin "slot_left_bottom_join_mask.bin"
.LeftTop        incbin "slot_left_top_mask.bin"
.Right          incbin "slot_right_mask.bin"
.RightJoin      incbin "slot_right_join_mask.bin"
.RightBottom    incbin "slot_right_bottom_mask.bin"
.RightTop       incbin "slot_right_top_mask.bin"
.RightTopJoin   incbin "slot_right_top_join_mask.bin"
Inventory:      ; спрайт сетки инвенторя
.Grid           incbin "inventory_grid.bin"

                endmodule

                endif ; ~ _GRAPHICS_UI_SLOTS_PACK_
