
                ifndef _GRAPHICS_ENVIRONMENT_TELEPORT_INCLUDE_
                define _GRAPHICS_ENVIRONMENT_TELEPORT_INCLUDE_

                module Teleport
Sprites:        ; анимации спрайтов
                FSprite {{24, 32, 0,  0}, OR_XOR_ATTR | PAGE_5, #C000 | Sprite._0}
Sprite:
._0             incbin "Teleport_0.spr"

                endmodule

                endif ; ~ _GRAPHICS_ENVIRONMENT_TELEPORT_INCLUDE_
