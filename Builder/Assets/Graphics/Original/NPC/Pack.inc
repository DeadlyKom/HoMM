
                ifndef _GRAPHICS_NPC_AXEMAN_PACK_
                define _GRAPHICS_NPC_AXEMAN_PACK_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Up",          Sprites.Up,         1
                GRAPH_HEADER "UpRight",     Sprites.RightUp,    8
                GRAPH_HEADER "Right",       Sprites.Right,      8
                GRAPH_HEADER "DownRight",   Sprites.RightDown,  8
                GRAPH_HEADER "Down",        Sprites.Down,       1
                GRAPH_HEADER "DownLeft",    Sprites.LeftDown,   8
                GRAPH_HEADER "Left",        Sprites.Left,       8
                GRAPH_HEADER "UpLeft",      Sprites.LeftUp,     8
                GRAPH_HEADER "Idle",        Sprites.Idle,       8
Graph.Num:      EQU ($-Graph) / FGraphicHeader
Sprites:        ; анимации спрайтов
.Ox             EQU -8
.Oy             EQU -20

.Up             SPRITE 26, 28,  1+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.Up_Idle

.RightUp        SPRITE 23, 27,  2+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_0
                SPRITE 25, 27,  2+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_1
                SPRITE 22, 27,  3+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_2
                SPRITE 18, 26,  6+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_3
                SPRITE 15, 25,  9+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_4
                SPRITE 14, 26,  9+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_5
                SPRITE 15, 26,  8+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_6
                SPRITE 18, 25,  5+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_7

.Right          SPRITE 11, 28, 12+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_0
                SPRITE 11, 28, 11+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_1
                SPRITE 13, 28, 10+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_2
                SPRITE 12, 28, 10+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_3
                SPRITE 12, 27, 11+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_4
                SPRITE 14, 27, 11+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_5
                SPRITE 16, 28,  9+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_6
                SPRITE 15, 28, 10+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_7

.RightDown      SPRITE 15, 27, 10+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_0
                SPRITE 14, 27, 10+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_1
                SPRITE 15, 27,  9+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_2
                SPRITE 16, 27,  9+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_3
                SPRITE 20, 27,  8+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_4
                SPRITE 20, 27,  8+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_5
                SPRITE 18, 27,  9+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_6
                SPRITE 17, 28, 10+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_7

.Down           SPRITE 26, 28,  5+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.Down_Idle

.LeftDown       SPRITE 13, 27,  9+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_0
                SPRITE 11, 27, 10+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_1
                SPRITE 15, 27,  8+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_2
                SPRITE 16, 27,  8+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_3
                SPRITE 17, 27,  8+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_4
                SPRITE 21, 27,  6+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_5
                SPRITE 20, 27,  7+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_6
                SPRITE 16, 28,  8+Sprites.Ox,  2+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_7

.Left           SPRITE 12, 28, 10+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_0
                SPRITE 13, 28,  9+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_1
                SPRITE 14, 28,  8+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_2
                SPRITE 13, 28,  9+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_3
                SPRITE 12, 27, 10+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_4
                SPRITE 14, 27,  8+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_5
                SPRITE 19, 28,  8+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_6
                SPRITE 16, 28,  9+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_7

.LeftUp         SPRITE 24, 27,  1+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_0
                SPRITE 24, 27,  1+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_1
                SPRITE 21, 27,  3+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_2
                SPRITE 21, 26,  3+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_3
                SPRITE 18, 25,  4+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_4
                SPRITE 17, 26,  4+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_5
                SPRITE 16, 26,  6+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_6
                SPRITE 20, 26,  3+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_7

.Idle           SPRITE 26, 28,  1+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.Up_Idle
                SPRITE 20, 27,  5+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightUp_Idle
                SPRITE 17, 29, 10+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Right_Idle
                SPRITE 26, 28,  6+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.RightDown_Idle
                SPRITE 26, 28,  5+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.Down_Idle
                SPRITE 26, 28,  4+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftDown_Idle
                SPRITE 18, 29,  8+Sprites.Ox,  0+Sprites.Oy, OR_XOR,  0, Sprite.Left_Idle
                SPRITE 23, 27,  2+Sprites.Ox,  1+Sprites.Oy, OR_XOR,  0, Sprite.LeftUp_Idle
Sprite:
.Up_Idle        incbin "up_idle.bin"

.RightUp_0      incbin "right_up_0.bin"
.RightUp_1      incbin "right_up_1.bin"
.RightUp_2      incbin "right_up_2.bin"
.RightUp_3      incbin "right_up_3.bin"
.RightUp_4      incbin "right_up_4.bin"
.RightUp_5      incbin "right_up_5.bin"
.RightUp_6      incbin "right_up_6.bin"
.RightUp_7      incbin "right_up_7.bin"
.RightUp_Idle   incbin "right_up_idle.bin"

.Right_0        incbin "right_0.bin"
.Right_1        incbin "right_1.bin"
.Right_2        incbin "right_2.bin"
.Right_3        incbin "right_3.bin"
.Right_4        incbin "right_4.bin"
.Right_5        incbin "right_5.bin"
.Right_6        incbin "right_6.bin"
.Right_7        incbin "right_7.bin"
.Right_Idle     incbin "right_idle.bin"

.RightDown_0    incbin "right_down_0.bin"
.RightDown_1    incbin "right_down_1.bin"
.RightDown_2    incbin "right_down_2.bin"
.RightDown_3    incbin "right_down_3.bin"
.RightDown_4    incbin "right_down_4.bin"
.RightDown_5    incbin "right_down_5.bin"
.RightDown_6    incbin "right_down_6.bin"
.RightDown_7    incbin "right_down_7.bin"
.RightDown_Idle incbin "right_down_idle.bin"

.Down_Idle      incbin "down_idle.bin"

.LeftDown_0     incbin "left_down_0.bin"
.LeftDown_1     incbin "left_down_1.bin"
.LeftDown_2     incbin "left_down_2.bin"
.LeftDown_3     incbin "left_down_3.bin"
.LeftDown_4     incbin "left_down_4.bin"
.LeftDown_5     incbin "left_down_5.bin"
.LeftDown_6     incbin "left_down_6.bin"
.LeftDown_7     incbin "left_down_7.bin"
.LeftDown_Idle  incbin "left_down_idle.bin"

.Left_0         incbin "left_0.bin"
.Left_1         incbin "left_1.bin"
.Left_2         incbin "left_2.bin"
.Left_3         incbin "left_3.bin"
.Left_4         incbin "left_4.bin"
.Left_5         incbin "left_5.bin"
.Left_6         incbin "left_6.bin"
.Left_7         incbin "left_7.bin"
.Left_Idle      incbin "left_idle.bin"

.LeftUp_0       incbin "left_up_0.bin"
.LeftUp_1       incbin "left_up_1.bin"
.LeftUp_2       incbin "left_up_2.bin"
.LeftUp_3       incbin "left_up_3.bin"
.LeftUp_4       incbin "left_up_4.bin"
.LeftUp_5       incbin "left_up_5.bin"
.LeftUp_6       incbin "left_up_6.bin"
.LeftUp_7       incbin "left_up_7.bin"
.LeftUp_Idle    incbin "left_up_idle.bin"

                endif ; ~ _GRAPHICS_NPC_AXEMAN_PACK_
