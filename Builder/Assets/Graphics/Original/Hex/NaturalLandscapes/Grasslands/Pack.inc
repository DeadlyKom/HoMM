
                ifndef _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
                define _GRAPHICS_HEXAGON_GRASSLANDS_PACK_

                ; блоковая таблица смещений, до первого спрайта
                ; после загрузки ассета в память его смещения преобразуются в абсолютные адреса
BlockTable      BIND_HEX_SPRITE Sprites._0, 0, 0, 0                             ; 0-ой гексагон
                ADD_BIND_HEX_SPRITE Sprites._1, 0, 0, 0
                ADD_BIND_HEX_SPRITE Sprites._2, 0, 0, 0
                ADD_BIND_HEX_SPRITE Sprites._3, 0, 0, 0
                ADD_BIND_HEX_SPRITE Sprites._4, 0, 0, 0
                ADD_BIND_HEX_SPRITE Sprites._5, 0, 0, 0
                ADD_BIND_HEX_SPRITE Sprites._6, 0, 0, 0
                EMPTY_HEX_SPRITE
                COUNT_HEX_SPRITE                                                ; количество гексагональных тайлов в блоке
Sprites:        ; таблицы смещений гексагонов
                ; если данные лежат сразу за смещением, количество анимайий ограничено нулём
                ; если анимации имеются хоть в одной половинке, таблица смещений должна быть полной

                ; номер анимации (максимум 8) * 12 байт + горизонтальное смещение (0-5 номер столбца) * 2
._0             ; 23
                incbin "sprite_1_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_1.bin"
._1             ; 160
                incbin "sprite_4_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_4.bin"
._2             ; 137
                incbin "sprite_6_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_6.bin"
._3             ; 133
                incbin "sprite_10_offsets.bin"                                  ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_10.bin"
._4             ; 46
                incbin "sprite_8_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_8.bin"
._5             ; 48
                incbin "sprite_2_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_2.bin"
._6             ; 111
                incbin "sprite_3_offsets.bin"                                   ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_3.bin"

                endif ; ~ _GRAPHICS_HEXAGON_GRASSLANDS_PACK_
