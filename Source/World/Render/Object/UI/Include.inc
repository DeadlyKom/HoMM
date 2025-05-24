
                ifndef _WORLD_RENDER_OBJECT_UI_INCLUDE_
                define _WORLD_RENDER_OBJECT_UI_INCLUDE_

                module UI
Begin           EQU $
                include "Draw.asm"
Indexes         ; индексы спрайтов в буфере спрайтов (Adr.SpriteInfoBuffer)

                DB #00                                                          ; "Idle"
                DB #00                                                          ; "Up"

                display " - Draw UI element:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_WORLD_RENDER_OBJECT_UI_INCLUDE_
