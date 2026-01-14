
                ifndef _GRAPHICS_HEXAGON_FOG_PACK_
                define _GRAPHICS_HEXAGON_FOG_PACK_

                include "CreateSprites.inc"

                ; блоковая таблица смещений, до первого спрайта
                ; после загрузки ассета в память его смещения преобразуются в абсолютные адреса
BlockTable      BIND_HEX_SPRITE Sprites._0, 1, 8, 0                             ; 0-ой гексагон
                EMPTY_HEX_SPRITE
                EMPTY_HEX_SPRITE
                EMPTY_HEX_SPRITE
                EMPTY_HEX_SPRITE
                EMPTY_HEX_SPRITE
                EMPTY_HEX_SPRITE
                EMPTY_HEX_SPRITE
                COUNT_HEX_SPRITE                                                ; количество гексагональных тайлов в блоке
Sprites:        ; таблицы смещений гексагонов
                ; если данные лежат сразу за смещением, количество анимайий ограничено нулём
                ; если анимации имеются хоть в одной половинке, таблица смещений должна быть полной


                ; (номер анимации (максимум 8) * 12 байт) * (дополнительный флаг 0-1) + горизонтальное смещение (0-5 номер столбца) * 2
._0             ; таблица смещений столбцов гексагона (6 столбцов по 2 байта)
                incbin "sprite_0_offsets.bin"
                EMPTY_HEX_OFFSET                                                ; необходимо заполнить
                EMPTY_HEX_OFFSET                                                ; пустыми смещениями
                EMPTY_HEX_OFFSET                                                ; т.к. при рендере нет
                EMPTY_HEX_OFFSET                                                ; возможности долго
                EMPTY_HEX_OFFSET                                                ; считать смещение
                EMPTY_HEX_OFFSET                                                ; 
                EMPTY_HEX_OFFSET                                                ; 
                ; таблица смещений
                incbin "sprite_8_offsets.bin"
                incbin "sprite_7_offsets.bin"
                incbin "sprite_6_offsets.bin"
                incbin "sprite_5_offsets.bin"
                incbin "sprite_4_offsets.bin"
                incbin "sprite_3_offsets.bin"
                incbin "sprite_2_offsets.bin"
                incbin "sprite_1_offsets.bin"
                
                ; INCBIN_HEX_SIZE_SPRITE формирует 2 байта длины блока, после идут данные

                ; графика спрайтов (флаг 0)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_0.bin"
                ; графика спрайтов (флаг 1)
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_8.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_7.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_6.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_5.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_4.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_3.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_2.bin"
                INCBIN_HEX_SIZE_SPRITE incbin "sprite_1.bin"

                endif ; ~ _GRAPHICS_HEXAGON_FOG_PACK_
