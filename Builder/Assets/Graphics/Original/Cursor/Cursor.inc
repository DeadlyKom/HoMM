
                ifndef _GRAPHICS_CURSOR_PACK_
                define _GRAPHICS_CURSOR_PACK_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Idle",        Idle,    Idle.Num
                GRAPH_HEADER "Click",       Click,   Click.Num
Graph.Num:      EQU ($-Graph) / FGraphicHeader

Idle:           ; анимации спрайтов курсора "бездействие"
                SPRITE 24, 23, -2, -1, OR_XOR_SAVE, 0, Sprite._0
                SPRITE 24, 23, -2, -1, OR_XOR_SAVE, 0, Sprite._1
                SPRITE 24, 24, -2, -2, OR_XOR_SAVE, 0, Sprite._2
.Num            EQU ($-Idle) / FSprite
Click:           ; анимации спрайтов курсора "клик"
                SPRITE 24, 23, -2, -1, OR_XOR_SAVE, 0, Sprite._0
                SPRITE 24, 19, -2,  1, OR_XOR_SAVE, 0, Sprite.Click
.Num            EQU ($-Click) / FSprite

Sprite:
._0             incbin "Hand_0.spr"
._1             incbin "Hand_1.spr"
._2             incbin "Hand_2.spr"
.Click          incbin "Hand_Click.spr"

                endif ; ~ _GRAPHICS_CURSOR_PACK_
