
                ifndef _GRAPHICS_ENVIRONMENT_TELEPORT_INCLUDE_
                define _GRAPHICS_ENVIRONMENT_TELEPORT_INCLUDE_

                module Teleport
Sprites:        ; анимации спрайтов
                SPRITE 24, 32, 0, -16, OR_XOR_ATTR, 0, Sprite._0
                SPRITE 24, 32, 0, -16, OR_XOR_ATTR, 0, Sprite._1
                SPRITE 24, 32, 0, -16, OR_XOR_ATTR, 0, Sprite._2
.Num            EQU ($-Sprites) / FSprite
Sprite:
._0             incbin "Teleport_0.spr"
._1             incbin "Teleport_1.spr"
._2             incbin "Teleport_2.spr"

                endmodule

                endif ; ~ _GRAPHICS_ENVIRONMENT_TELEPORT_INCLUDE_
