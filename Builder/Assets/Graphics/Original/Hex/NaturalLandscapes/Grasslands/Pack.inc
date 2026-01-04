
                ifndef _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
                define _GRAPHICS_HEXAGON_GRASSLANDS_PACK_

                ; блоковая таблица смещений, до первого спрайта
                ; после загрузки ассета в память его смещения преобразуются в абсолютные адреса
BlockTable      DW Sprites._0                                                   ; 0-ой гексагон
                DW Sprites._1-2
                DW Sprites._2-4
                DW Sprites._3-6
                DW Sprites._4-8
                DW Sprites._5-10
                DW Sprites._6-12
                DW #0000
                DB #07                                                          ; количество гексагональных тайлов в блоке
Sprites:        ; таблицы смещений гексагонов
                ; номер анимации (максимум 8) * 12 байт + горизонтальное смещение (0-5 номер столбца) * 2
._0             ; 23
                incbin "sprite_1_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_1.bin"
._1             ; 160
                incbin "sprite_4_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_4.bin"
._2             ; 137
                incbin "sprite_6_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_6.bin"
._3             ; 133
                incbin "sprite_10_offsets.bin"                                  ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_10.bin"
._4             ; 46
                incbin "sprite_8_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_8.bin"
._5             ; 48
                incbin "sprite_2_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_2.bin"
._6             ; 111
                incbin "sprite_3_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_3.bin"

                endif ; ~ _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
