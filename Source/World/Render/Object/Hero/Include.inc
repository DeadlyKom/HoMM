
                ifndef _WORLD_RENDER_OBJECT_HERO_INCLUDE_
                define _WORLD_RENDER_OBJECT_HERO_INCLUDE_

                module Hero
Begin           EQU $
                include "Draw.asm"
Indexes         ; индексы спрайтов в буфере спрайтов (Adr.SpriteInfoBuffer)

                DB #00                                                          ; "Idle"
                DB #00                                                          ; "Up"
                DB #00                                                          ; "UpRight"
                DB #00                                                          ; "Right"
                DB #00                                                          ; "DownRight"
                DB #00                                                          ; "Down"
                DB #00                                                          ; "DownLeft"
                DB #00                                                          ; "Left"
                DB #00                                                          ; "UpLeft"

                display " - Draw hero object:\t\t\t\t", /A, Begin, " = busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_WORLD_RENDER_OBJECT_HERO_INCLUDE_
