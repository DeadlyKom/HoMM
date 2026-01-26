
                ifndef _MACRO_GRAPHIC_HEX_
                define _MACRO_GRAPHIC_HEX_

                ; макросы позволяютт связать графические пакеты с ID ассетом
MAKE_TO_GRAPHICS_PACKAGE macro Label?, AssetID?
GRAPHICS_PACKAGE_COUNTER  defl 0                                                ; счётчик гексагональных тайлов
@Label?         EQU GRAPHICS_PACKAGE_COUNTER
                DB AssetID?
GRAPHICS_PACKAGE_COUNTER = GRAPHICS_PACKAGE_COUNTER+1
                endm
ADD_TO_GRAPHICS_PACKAGE macro Label?, AssetID?
Label?          EQU GRAPHICS_PACKAGE_COUNTER
                DB AssetID?
GRAPHICS_PACKAGE_COUNTER = GRAPHICS_PACKAGE_COUNTER+1
                endm

                ; таблица сопоставления гексагональных тайлов и графического пакетов, где
                ;  1. индекс массива - ID гексагонального тайла
                ;  2. первый байт - индекс в массиве FMapHeader.GraphicPack
                ;  3. второй байт - смещение внутри текущего графического пакета (0-7)
                ;
                ;   | <---------- первый байт ---------- > |   | <---------- второй байт ---------- >  |
                ;
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |   |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | UB | I6 | I5 | I4 | I3 | I2 | I1 | I0 |   | O2 | O1 | O0 | .. | .. | .. | .. | .. |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;
                ;   UB      [15]        - флаг, использования гесагонального тайла (1 - не используется)
                ;   I6-I0   [14..8]     - ндекс в массиве FMapHeader.GraphicPack
                ;   O2-O0   [7..5]      - смещение внутри текущего графического пакета (0-7)
MAKE_HEXTILE_BIND macro IndexInListGraphicsPackage?, Offset?
                DB MAP_HEXTILE_USABLE | (IndexInListGraphicsPackage? & 0x7F)
                DB (Offset?) << 5
                endm
HEXTILE_NOT_USABLE macro
                DB MAP_HEXTILE_NOT_USABLE
                DB #00
                endm

                ; макросы формирования гексагональных спрайтов
BIND_HEX_SPRITE macro Offset?, AmountAnimation_0F?, AmountAnimation_F0?, Flags?   ; добавление спрайта (всегда первый)
HEX_SPRITE      defl 0
                DW Offset?
                DB ((AmountAnimation_F0? & 0x0F) << 4) | ((AmountAnimation_0F?) & 0x0F)
                DB Flags?
HEX_SPRITE      = HEX_SPRITE + 1
                endm
ADD_BIND_HEX_SPRITE  macro Offset?, AmountAnimation_0F?, AmountAnimation_F0?, Flags? ; добавление спрайта
                DW (Offset?) - HEX_SPRITE * 4
                DB ((AmountAnimation_F0? & 0x07) << 4) | ((AmountAnimation_0F?) & 0x07)
                DB Flags?
HEX_SPRITE      = HEX_SPRITE + 1
                endm
EMPTY_HEX_SPRITE macro                                                          ; пустой спрайт
                DW #0000, #0000
                endm
EMPTY_HEX_OFFSET macro                                                          ; пустые смещения
                DS 12, 0
                endm
COUNT_HEX_SPRITE macro                                                          ; количество спрайтов
                DB HEX_SPRITE
                endm
INCBIN_HEX_SIZE_SPRITE macro Include?                                           ; формирует 2 байта длины блока, после идут данные
                DW .Size
.Begin          EQU $
                Include?
.Size           EQU $-.Begin
                endm
CREATE_HEX_SPRITE macro SpriteName?, SpriteOffset?, Include_0?, Include_1?, Include_2?, Include_3?, Include_4?, Include_5?                                           ; формирует 2 байта длины блока, после идут данные
.Begin_0        EQU $
                DW Kernel.Hex.Column.x2_
                DW Kernel.Hex.Column.x2_
                Include_0?
.Size_0         EQU $-.Begin_0
.Begin_1        EQU $
                DW Kernel.Hex.Column.x6_
                DW Kernel.Hex.Column.x6_
                Include_1?
.Size_1         EQU $-.Begin_1
.Begin_2        EQU $
                DW Kernel.Hex.Column.x8
                DW Kernel.Hex.Column.x8
                Include_2?
.Size_2         EQU $-.Begin_2
.Begin_3        EQU $
                DW Kernel.Hex.Column.x8
                DW Kernel.Hex.Column.x8
                Include_3?
.Size_3         EQU $-.Begin_3
.Begin_4        EQU $
                DW Kernel.Hex.Column.x6_
                DW Kernel.Hex.Column.x6_
                Include_4?
.Size_4         EQU $-.Begin_4
.Begin_5        EQU $
                DW Kernel.Hex.Column.x2_
                DW Kernel.Hex.Column.x2_
                Include_5?
.Size_5         EQU $-.Begin_5
                SpriteName?, .Begin_0, .Size_0 + .Size_1 + .Size_2 + .Size_3 + .Size_4 + .Size_5

.BeginOffsets   EQU $
                DW #0000
                DW .Size_0
                DW .Size_0 + .Size_1
                DW .Size_0 + .Size_1 + .Size_2
                DW .Size_0 + .Size_1 + .Size_2 + .Size_3
                DW .Size_0 + .Size_1 + .Size_2 + .Size_3 + .Size_4
.SizeOffsets    EQU $-.BeginOffsets
                SpriteOffset?, .BeginOffsets, .SizeOffsets
                endm
                
                endif ; ~_MACRO_GRAPHIC_HEX_
