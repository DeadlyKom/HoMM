
                ifndef _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
                define _GRAPHICS_HEXAGON_GRASSLANDS_PACK_

                ; таблица смещений, до первого спрайта
                ; после загрузки ассета в память его смещения преобразуются в абсолютные адреса
                DW Sprites._0
                DW #0000
                DW #0000
                DW #0000
                DW #0000
                DW #0000
                DW #0000
                DW #0000
                DB #01                                                          ; количество гексагональных тайлов в блоке
Sprites:
._0             incbin "sprite_1_offsets.bin"
                incbin "sprite_1.bin"

                endif ; ~ _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
