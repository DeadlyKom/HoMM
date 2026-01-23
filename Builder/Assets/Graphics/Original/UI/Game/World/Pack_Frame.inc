
                ifndef _GRAPHICS_UI_GAME_WORLD_PACK_FRAME_
                define _GRAPHICS_UI_GAME_WORLD_PACK_FRAME_

                module Frame
                ORG #0000

                DB Graph.Num
Graph:          EQU $
                SPRITE_BLOCK 192,   8,   0,   0, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Edge_up_down
                SPRITE_BLOCK 192,   8,   0, 184, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_MIRROR_VERTICAL   | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Edge_up_down
                SPRITE_BLOCK   8, 176,   0,   8, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Edge_left_right
                SPRITE_BLOCK   8, 176, 184,   8, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Edge_left_right

                SPRITE_BLOCK  64,   8, 192,   8, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Minimap_up_down
                SPRITE_BLOCK  64,   8, 192,  64, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_MIRROR_VERTICAL   | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Minimap_up_down
                SPRITE_BLOCK   8,  48, 192,  16, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Minimap_left_right
                SPRITE_BLOCK   8,  48, 248,  16, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Minimap_left_right
Graph.Num:      EQU ($-Graph) / FSpriteBlock
Sprite:
.Edge_up_down       incbin "ornament_edge_up_down.bin"
.Edge_left_right    incbin "ornament_edge_left_right.bin"
.Minimap_up_down    incbin "ornament_minimap_up_down.bin"
.Minimap_left_right incbin "ornament_minimap_left_right.bin"

                savebin "Builder/Assets/Graphics/Original/UI/GameWorld_Frame.pack", 0, $
                endmodule

                endif ; ~ _GRAPHICS_UI_GAME_WORLD_PACK_FRAME_
