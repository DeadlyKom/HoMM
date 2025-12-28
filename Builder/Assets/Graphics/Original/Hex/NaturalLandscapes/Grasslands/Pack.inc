
                ifndef _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
                define _GRAPHICS_HEXAGON_GRASSLANDS_PACK_

                ; блоковая таблица смещений, до первого спрайта
                ; после загрузки ассета в память его смещения преобразуются в абсолютные адреса
BlockTable      DW Sprites._0                                                   ; 0-ой гексагон
                DW Sprites._1-2
                DW Sprites._2-4
                DW Sprites._3-6
                DW #0000
                DW #0000
                DW #0000
                DW #0000
                DB #04                                                          ; количество гексагональных тайлов в блоке
Sprites:        ; таблицы смещений гексагонов
                ; номер анимации (максимум 8) * 12 байт + горизонтальное смещение (0-5 номер столбца) * 2
._0             incbin "sprite_1_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_1.bin"
._1             incbin "sprite_4_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_4.bin"
._2             incbin "sprite_6_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_6.bin"
._3             incbin "sprite_10_offsets.bin"                                  ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_10.bin"
                endif ; ~ _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
