
                ifndef _GRAPHICS_HERO_PACK_
                define _GRAPHICS_HERO_PACK_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Up",          Sprites.Up,         8
                GRAPH_HEADER "UpRight",     Sprites.UpRight,    8
                GRAPH_HEADER "Right",       Sprites.Right,      8
                GRAPH_HEADER "DownRight",   Sprites.DownRight,  8
                GRAPH_HEADER "Down",        Sprites.Down,       8
                GRAPH_HEADER "DownLeft",    Sprites.DownLeft,   8
                GRAPH_HEADER "Left",        Sprites.Left,       8
                GRAPH_HEADER "UpLeft",      Sprites.UpLeft,     8
                GRAPH_HEADER "Idle",        Sprites.Idle,       8
Graph.Num:      EQU ($-Graph) / FGraphicHeader

Sprites:        ; анимации спрайтов

.Up             SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Up_0
                SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Up_1
                SPRITE 16, 29,  8,  1, OR_XOR, 0, Sprite.Up_2
                SPRITE 16, 30,  8,  0, OR_XOR, 0, Sprite.Up_3
                SPRITE 16, 30,  8,  1, OR_XOR, 0, Sprite.Up_4
                SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Up_5
                SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Up_6
                SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Up_7

.UpRight        SPRITE 20, 28,  6,  2, OR_XOR, 0, Sprite.UpRight_0
                SPRITE 21, 28,  6,  2, OR_XOR, 0, Sprite.UpRight_1
                SPRITE 22, 28,  5,  1, OR_XOR, 0, Sprite.UpRight_2
                SPRITE 22, 29,  5,  1, OR_XOR, 0, Sprite.UpRight_3
                SPRITE 22, 29,  4,  1, OR_XOR, 0, Sprite.UpRight_4
                SPRITE 20, 29,  7,  2, OR_XOR, 0, Sprite.UpRight_5
                SPRITE 19, 28,  7,  2, OR_XOR, 0, Sprite.UpRight_6
                SPRITE 19, 28,  7,  2, OR_XOR, 0, Sprite.UpRight_7

.Right          SPRITE 26, 26,  3,  4, OR_XOR, 0, Sprite.Right_0
                SPRITE 27, 26,  2,  4, OR_XOR, 0, Sprite.Right_1
                SPRITE 27, 26,  2,  3, OR_XOR, 0, Sprite.Right_2
                SPRITE 28, 28,  1,  3, OR_XOR, 0, Sprite.Right_3
                SPRITE 27, 28,  2,  3, OR_XOR, 0, Sprite.Right_4
                SPRITE 26, 27,  3,  3, OR_XOR, 0, Sprite.Right_5
                SPRITE 26, 26,  3,  4, OR_XOR, 0, Sprite.Right_6
                SPRITE 26, 26,  3,  4, OR_XOR, 0, Sprite.Right_7

.DownRight      SPRITE 21, 26,  6,  3, OR_XOR, 0, Sprite.DownRight_0
                SPRITE 21, 27,  6,  3, OR_XOR, 0, Sprite.DownRight_1
                SPRITE 21, 28,  5,  3, OR_XOR, 0, Sprite.DownRight_2
                SPRITE 22, 27,  4,  3, OR_XOR, 0, Sprite.DownRight_3
                SPRITE 21, 27,  5,  3, OR_XOR, 0, Sprite.DownRight_4
                SPRITE 21, 27,  5,  4, OR_XOR, 0, Sprite.DownRight_5
                SPRITE 20, 27,  6,  4, OR_XOR, 0, Sprite.DownRight_6
                SPRITE 20, 27,  6,  4, OR_XOR, 0, Sprite.DownRight_7

.Down           SPRITE 16, 28,  8,  2, OR_XOR, 0, Sprite.Down_0
                SPRITE 16, 28,  8,  2, OR_XOR, 0, Sprite.Down_1
                SPRITE 16, 28,  8,  1, OR_XOR, 0, Sprite.Down_2
                SPRITE 16, 30,  8,  1, OR_XOR, 0, Sprite.Down_3
                SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Down_4
                SPRITE 16, 28,  8,  3, OR_XOR, 0, Sprite.Down_5
                SPRITE 16, 28,  8,  3, OR_XOR, 0, Sprite.Down_6
                SPRITE 16, 28,  8,  3, OR_XOR, 0, Sprite.Down_7

.DownLeft       SPRITE 21, 26,  6,  3, M_OR_XOR, 0, Sprite.DownRight_0
                SPRITE 21, 27,  6,  3, M_OR_XOR, 0, Sprite.DownRight_1
                SPRITE 21, 28,  5,  3, M_OR_XOR, 0, Sprite.DownRight_2
                SPRITE 22, 27,  4,  3, M_OR_XOR, 0, Sprite.DownRight_3
                SPRITE 21, 27,  5,  3, M_OR_XOR, 0, Sprite.DownRight_4
                SPRITE 21, 27,  5,  4, M_OR_XOR, 0, Sprite.DownRight_5
                SPRITE 20, 27,  6,  4, M_OR_XOR, 0, Sprite.DownRight_6
                SPRITE 20, 27,  6,  4, M_OR_XOR, 0, Sprite.DownRight_7

.Left           SPRITE 26, 26,  3,  4, M_OR_XOR, 0, Sprite.Right_0
                SPRITE 27, 26,  2,  4, M_OR_XOR, 0, Sprite.Right_1
                SPRITE 27, 26,  2,  3, M_OR_XOR, 0, Sprite.Right_2
                SPRITE 28, 28,  1,  3, M_OR_XOR, 0, Sprite.Right_3
                SPRITE 27, 28,  2,  3, M_OR_XOR, 0, Sprite.Right_4
                SPRITE 26, 27,  3,  3, M_OR_XOR, 0, Sprite.Right_5
                SPRITE 26, 26,  3,  4, M_OR_XOR, 0, Sprite.Right_6
                SPRITE 26, 26,  3,  4, M_OR_XOR, 0, Sprite.Right_7

.UpLeft         SPRITE 20, 28,  6,  2, M_OR_XOR, 0, Sprite.UpRight_0
                SPRITE 21, 28,  6,  2, M_OR_XOR, 0, Sprite.UpRight_1
                SPRITE 22, 28,  5,  1, M_OR_XOR, 0, Sprite.UpRight_2
                SPRITE 22, 29,  5,  1, M_OR_XOR, 0, Sprite.UpRight_3
                SPRITE 22, 29,  4,  1, M_OR_XOR, 0, Sprite.UpRight_4
                SPRITE 20, 29,  7,  2, M_OR_XOR, 0, Sprite.UpRight_5
                SPRITE 19, 28,  7,  2, M_OR_XOR, 0, Sprite.UpRight_6
                SPRITE 19, 28,  7,  2, M_OR_XOR, 0, Sprite.UpRight_7

.Idle           SPRITE 16, 29,  8,  2, OR_XOR, 0, Sprite.Up_Idle
                SPRITE 21, 28,  6,  2, OR_XOR, 0, Sprite.UpRight_Idle
                SPRITE 25, 26,  4,  4, OR_XOR, 0, Sprite.Right_Idle
                SPRITE 21, 28,  6,  3, OR_XOR, 0, Sprite.DownRight_Idle
                SPRITE 16, 30,  8,  1, OR_XOR, 0, Sprite.Down_Idle
                SPRITE 21, 28,  6+21,  3, M_OR_XOR, 0, Sprite.DownRight_Idle
                SPRITE 25, 26,  4+25,  4, M_OR_XOR, 0, Sprite.Right_Idle
                SPRITE 21, 28,  6+21,  2, M_OR_XOR, 0, Sprite.UpRight_Idle
Sprite:
.Up_0           incbin "Up_0.spr"
.Up_1           incbin "Up_1.spr"
.Up_2           incbin "Up_2.spr"
.Up_3           incbin "Up_3.spr"
.Up_4           incbin "Up_4.spr"
.Up_5           incbin "Up_5.spr"
.Up_6           incbin "Up_6.spr"
.Up_7           incbin "Up_7.spr"
.Up_Idle        incbin "Up_idle.spr"

.Down_0         incbin "Down_0.spr"
.Down_1         incbin "Down_1.spr"
.Down_2         incbin "Down_2.spr"
.Down_3         incbin "Down_3.spr"
.Down_4         incbin "Down_4.spr"
.Down_5         incbin "Down_5.spr"
.Down_6         incbin "Down_6.spr"
.Down_7         incbin "Down_7.spr"
.Down_Idle      incbin "Down_idle.spr"

.UpRight_0      incbin "Up-Right_0.spr"
.UpRight_1      incbin "Up-Right_1.spr"
.UpRight_2      incbin "Up-Right_2.spr"
.UpRight_3      incbin "Up-Right_3.spr"
.UpRight_4      incbin "Up-Right_4.spr"
.UpRight_5      incbin "Up-Right_5.spr"
.UpRight_6      incbin "Up-Right_6.spr"
.UpRight_7      incbin "Up-Right_7.spr"
.UpRight_Idle   incbin "Up-Right_idle.spr"

.Right_0        incbin "Right_0.spr"
.Right_1        incbin "Right_1.spr"
.Right_2        incbin "Right_2.spr"
.Right_3        incbin "Right_3.spr"
.Right_4        incbin "Right_4.spr"
.Right_5        incbin "Right_5.spr"
.Right_6        incbin "Right_6.spr"
.Right_7        incbin "Right_7.spr"
.Right_Idle     incbin "Right_idle.spr"

.DownRight_0    incbin "Down-Right_0.spr"
.DownRight_1    incbin "Down-Right_1.spr"
.DownRight_2    incbin "Down-Right_2.spr"
.DownRight_3    incbin "Down-Right_3.spr"
.DownRight_4    incbin "Down-Right_4.spr"
.DownRight_5    incbin "Down-Right_5.spr"
.DownRight_6    incbin "Down-Right_6.spr"
.DownRight_7    incbin "Down-Right_7.spr"
.DownRight_Idle incbin "Down-Right_idle.spr"

                endif ; ~ _GRAPHICS_HERO_PACK_
