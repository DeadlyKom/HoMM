
                ifndef _MODULE_WORLD_SPRITE_UI_
                define _MODULE_WORLD_SPRITE_UI_

                module UI
; -----------------------------------------
; загрузка и инициализация спрайтов UI
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           LD A, ASSETS_ID_UI_GAMEPLAY_COMMON_PACK
                LD HL, World.Base.Render.Object.UI.Indexes
                LD DE, .HashSequence
                JP World.Sprite.Load
; ⚠️ ВАЖНО ⚠️
;   количество хешей и размер массива UI.Indexes должны точно
;   соответствовать количеству FGraphicHeader в пакете ASSETS_ID_UI_GAMEPLAY_COMMON_PACK
.HashSequence   lua allpass
                Hash16("Pointer")
                Hash16("FrameHero")
                Hash16("SmallHero")
                endlua

                display " - Sprite initialize UI:\t\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s)  ]"

                endmodule

                endif ; ~ _MODULE_WORLD_SPRITE_UI_
