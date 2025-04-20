
                ifndef _GRAPHICS_ENVIRONMENT_NECROPOLIS_INCLUDE_
                define _GRAPHICS_ENVIRONMENT_NECROPOLIS_INCLUDE_

                module Necropolis
Sprites:        ;
                SPRITE 16, 24,   0, -32, OR_XOR_ATTR, 0, Sprite_OX._0
                SPRITE 16, 16,   0,  -8, OR_XOR_ATTR, 0, Sprite_OX._1
                SPRITE 16, 24,  24, -64, OR_XOR_ATTR, 0, Sprite_OX._2
                SPRITE_LINKER Flag.Num, Flag                                    ; пика с флагом
                SPRITE_LINKER MagicBall_40.Num, MagicBall_40
                SPRITE_LINKER MagicBall_41.Num, MagicBall_41
                SPRITE_LINKER MagicBall_42.Num, MagicBall_42
                SPRITE_LINKER Fire.Num, Fire                                    ; огонь
                SPRITE  8, 16,  72, -48, OR_XOR_ATTR, 0, Sprite_OX._6
                SPRITE  8, 32,  80, -24, OR_XOR_ATTR, 0, Sprite_OX._7
                
                SPRITE 24, 32,  40, -64, LD_ATTR, 0, Sprite_LD._0
                SPRITE  8, 16,  64, -48, LD_ATTR, 0, Sprite_LD._1
                SPRITE 24, 24,  16, -24, LD_ATTR, 0, Sprite_LD._2
                SPRITE 24, 32,  40, -32, LD_ATTR, 0, Sprite_LD._3
                SPRITE 16, 32,  64, -32, LD_ATTR, 0, Sprite_LD._4
                SPRITE 24,  8,  16,   0, LD_ATTR, 0, Sprite_LD._5
                SPRITE 32,  8,  48,   0, LD_ATTR, 0, Sprite_LD._6
.Num            EQU ($-Sprites) / FSprite
Fire:           ; огонь
                SPRITE  8, 16,  64, -64, LD_ATTR, 0, Sprite_LD._5_0
                SPRITE  8, 16,  64, -64, LD_ATTR, 0, Sprite_LD._5_1
                SPRITE  8, 16,  64, -64, LD_ATTR, 0, Sprite_LD._5_2
.Num            EQU ($-Fire) / FSprite
Flag:           ; пика с флагом
                SPRITE 24, 16,  16, -40, OR_XOR_ATTR, 0, Sprite_OX._3_0
                SPRITE 24, 16,  16, -40, OR_XOR_ATTR, 0, Sprite_OX._3_1
                SPRITE 24, 16,  16, -40, OR_XOR_ATTR, 0, Sprite_OX._3_2
.Num            EQU ($-Flag) / FSprite

MagicBall_40    ; магический шар 1/3
                SPRITE 16, 16,  32, -80, OR_XOR_ATTR, 0, Sprite_OX._40_0
                SPRITE 16, 16,  32, -80, OR_XOR_ATTR, 0, Sprite_OX._40_1
                SPRITE 16, 16,  32, -80, OR_XOR_ATTR, 0, Sprite_OX._40_2
.Num            EQU ($-MagicBall_40) / FSprite
MagicBall_41    ; магический шар 2/3
                SPRITE  8, 24,  48, -88, OR_XOR_ATTR, 0, Sprite_OX._41_0
                SPRITE  8, 24,  48, -88, OR_XOR_ATTR, 0, Sprite_OX._41_1
                SPRITE  8, 24,  48, -88, OR_XOR_ATTR, 0, Sprite_OX._41_2
.Num            EQU ($-MagicBall_41) / FSprite
MagicBall_42    ; магический шар 3/3
                SPRITE 16, 16,  56, -80, OR_XOR_ATTR, 0, Sprite_OX._42_0
                SPRITE 16, 16,  56, -80, OR_XOR_ATTR, 0, Sprite_OX._42_1
                SPRITE 16, 16,  56, -80, OR_XOR_ATTR, 0, Sprite_OX._42_2
.Num            EQU ($-MagicBall_42) / FSprite
Sprite_OX:
._0             incbin "Necropolis_OX_0.spr"
._1             incbin "Necropolis_OX_1.spr"
._2             incbin "Necropolis_OX_2.spr"                                    ; левый болкон
; магический шар
._40_0          incbin "Necropolis_OX_40_0.spr"
._40_1          incbin "Necropolis_OX_40_1.spr"
._40_2          incbin "Necropolis_OX_40_2.spr"
._41_0          incbin "Necropolis_OX_41_0.spr"
._41_1          incbin "Necropolis_OX_41_1.spr"
._41_2          incbin "Necropolis_OX_41_2.spr"
._42_0          incbin "Necropolis_OX_42_0.spr"
._42_1          incbin "Necropolis_OX_42_1.spr"
._42_2          incbin "Necropolis_OX_42_2.spr"
; пика с флагом
._3_0           incbin "Necropolis_OX_3_0.spr"
._3_1           incbin "Necropolis_OX_3_1.spr"
._3_2           incbin "Necropolis_OX_3_2.spr"

._6             incbin "Necropolis_OX_6.spr"                                    ; правый болкон
._7             incbin "Necropolis_OX_7.spr"                                    ; правая скала
Sprite_LD:
._0             incbin "Necropolis_LD_0.spr"
._1             incbin "Necropolis_LD_1.spr"
._2             incbin "Necropolis_LD_2.spr"
._3             incbin "Necropolis_LD_3.spr"
._4             incbin "Necropolis_LD_4.spr"
._5             incbin "Necropolis_LD_5.spr"
._6             incbin "Necropolis_LD_6.spr"
                ; огонь
._5_0           incbin "Necropolis_LD_5_0.spr"
._5_1           incbin "Necropolis_LD_5_1.spr"
._5_2           incbin "Necropolis_LD_5_2.spr"

                endmodule

                endif ; ~ _GRAPHICS_ENVIRONMENT_NECROPOLIS_INCLUDE_
