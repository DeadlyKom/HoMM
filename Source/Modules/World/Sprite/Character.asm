
                ifndef _MODULE_WORLD_SPRITE_HERO_
                define _MODULE_WORLD_SPRITE_HERO_

                module Character
; -----------------------------------------
; загрузка и инициализация спрайтов персонажа
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           LD A, ASSETS_ID_HERO_PACK
                LD HL, World.Base.Render.Object.Character.Indexes
                LD DE, .HashSequence
                JP World.Sprite.Load
; ⚠️ ВАЖНО ⚠️
;   количество хешей и размер массива Character.Indexes должны точно
;   соответствовать количеству FGraphicHeader в пакете ASSETS_ID_HERO_PACK
.HashSequence
                lua allpass
                Hash16("Idle")
                Hash16("Up")
                Hash16("UpRight")
                Hash16("Right")
                Hash16("DownRight")
                Hash16("Down")
                Hash16("DownLeft")
                Hash16("Left")
                Hash16("UpLeft")
                endlua

                display " - Sprite initialize character:\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s)  ]"

                endmodule

                endif ; ~ _MODULE_WORLD_SPRITE_HERO_
