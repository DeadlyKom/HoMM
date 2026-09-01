
                ifndef _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_
                define _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_

                module Icons
SpriteInfo:     SPRITE 23, 23,  0,  0, OR_XOR,  0, Sprite.Diamond
                SPRITE 13, 20,  0,  0, OR_XOR,  0, Sprite.Character
Sprite:
.Diamond        incbin "small_diamond.bin"
.Character      incbin "character.bin"
                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_
