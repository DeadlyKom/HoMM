
                ifndef _GRAPHICS_ARROW_PATH_PACK_
                define _GRAPHICS_ARROW_PATH_PACK_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Passable",        Passable,   Passable.Num
                GRAPH_HEADER "Impassable",      Impassable, Impassable.Num
Graph.Num:      EQU ($-Graph) / FGraphicHeader

Passable:       ; спрайты стрелок пути "доступных" 
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.EndPoint
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_0
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_1
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_2
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_3
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_4
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_5
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_6
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_7
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_8
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_9
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_10
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_11
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_12
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_13
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_14
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_15
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_16
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_17
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_18
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_19
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_20
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_21
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_22
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Passable.Path_23
.Num            EQU ($-Passable) / FSprite

Impassable:     ; спрайты стрелок пути "недоступных" 
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.EndPoint
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_0
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_1
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_2
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_3
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_4
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_5
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_6
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_7
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_8
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_9
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_10
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_11
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_12
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_13
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_14
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_15
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_16
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_17
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_18
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_19
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_20
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_21
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_22
                SPRITE 16, 16, 0, 0, OR_XOR, 0, Sprite_Impassable.Path_23
.Num            EQU ($-Impassable) / FSprite

Sprite_Passable:
.EndPoint       incbin "End_Point.spr"
.Path_0         incbin "Path_0.spr"
.Path_1         incbin "Path_1.spr"
.Path_2         incbin "Path_2.spr"
.Path_3         incbin "Path_3.spr"
.Path_4         incbin "Path_4.spr"
.Path_5         incbin "Path_5.spr"
.Path_6         incbin "Path_6.spr"
.Path_7         incbin "Path_7.spr"
.Path_8         incbin "Path_8.spr"
.Path_9         incbin "Path_9.spr"
.Path_10        incbin "Path_10.spr"
.Path_11        incbin "Path_11.spr"
.Path_12        incbin "Path_12.spr"
.Path_13        incbin "Path_13.spr"
.Path_14        incbin "Path_14.spr"
.Path_15        incbin "Path_15.spr"
.Path_16        incbin "Path_16.spr"
.Path_17        incbin "Path_17.spr"
.Path_18        incbin "Path_18.spr"
.Path_19        incbin "Path_19.spr"
.Path_20        incbin "Path_20.spr"
.Path_21        incbin "Path_21.spr"
.Path_22        incbin "Path_22.spr"
.Path_23        incbin "Path_23.spr"

Sprite_Impassable:
.EndPoint       incbin "End_Point_.spr"
.Path_0         incbin "Path_0_.spr"
.Path_1         incbin "Path_1_.spr"
.Path_2         incbin "Path_2_.spr"
.Path_3         incbin "Path_3_.spr"
.Path_4         incbin "Path_4_.spr"
.Path_5         incbin "Path_5_.spr"
.Path_6         incbin "Path_6_.spr"
.Path_7         incbin "Path_7_.spr"
.Path_8         incbin "Path_8_.spr"
.Path_9         incbin "Path_9_.spr"
.Path_10        incbin "Path_10_.spr"
.Path_11        incbin "Path_11_.spr"
.Path_12        incbin "Path_12_.spr"
.Path_13        incbin "Path_13_.spr"
.Path_14        incbin "Path_14_.spr"
.Path_15        incbin "Path_15_.spr"
.Path_16        incbin "Path_16_.spr"
.Path_17        incbin "Path_17_.spr"
.Path_18        incbin "Path_18_.spr"
.Path_19        incbin "Path_19_.spr"
.Path_20        incbin "Path_20_.spr"
.Path_21        incbin "Path_21_.spr"
.Path_22        incbin "Path_22_.spr"
.Path_23        incbin "Path_23_.spr"

                endif ; ~ _GRAPHICS_ARROW_PATH_PACK_
