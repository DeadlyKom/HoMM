
                ifndef _GRAPHICS_CURSOR_INCLUDE_
                define _GRAPHICS_CURSOR_INCLUDE_

                module Cursor
Sprites:        ; анимации спрайтов
                FSprite {{24, 23, -2, -1}, 0, OR_XOR_SAVE | PAGE_5, Sprite._0}
                FSprite {{24, 23, -2, -1}, 0, OR_XOR_SAVE | PAGE_5, Sprite._1}
                FSprite {{24, 24, -2, -2}, 0, OR_XOR_SAVE | PAGE_5, Sprite._2}
Sprite:
._0             incbin "Hand_0.spr"
._1             incbin "Hand_1.spr"
._2             incbin "Hand_2.spr"

                endmodule

                endif ; ~ _GRAPHICS_CURSOR_INCLUDE_
