
                ifndef _MODULE_WORLD_DISPLAY_GAMEPLAY_FRAME_
                define _MODULE_WORLD_DISPLAY_GAMEPLAY_FRAME_
; -----------------------------------------
; отображение рамки игрового окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameplayFrame:  ; отображение рамки игрового окна
                LD HL, Frame
                JP Draw.SpriteNotBound

.Ornament       ; отображение внутреннего орнамента рамки игрового окна
                LD HL, Ornament
                JP Draw.SpriteNotBound

                display " - Display gameplay frame:\t\t\t\t\t\t= busy [ ", /D, $-GameplayFrame, " byte(s) ]"

                endif ; ~_MODULE_WORLD_DISPLAY_GAMEPLAY_FRAME_
