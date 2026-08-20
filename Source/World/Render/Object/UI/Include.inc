
                ifndef _WORLD_RENDER_OBJECT_UI_INCLUDE_
                define _WORLD_RENDER_OBJECT_UI_INCLUDE_

                module UI
Begin           EQU $
                include "Draw.asm"
                include "Draw_NotAnchor.asm"
                include "Draw_IconCharacter.asm"
Indexes         ; индексы спрайтов в буфере спрайтов (Adr.SpriteInfoBuffer)
                DB #00                                                          ; "Pointer"
                DB #00                                                          ; "FrameHero"
                DB #00                                                          ; "SmallHero"
                DB #00                                                          ; "Standard"

                display " - Draw UI element:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_WORLD_RENDER_OBJECT_UI_INCLUDE_
