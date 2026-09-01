
                ifndef _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_
                define _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_

                module Icons
SpriteInfo:     SPRITE 23, 23,  0,  0, OR_XOR,  0, Sprite.Diamond
                SPRITE 13, 20,  0,  0, OR_XOR,  0, Sprite.Character
                SPRITE 22, 21,  0,  0, OR_XOR,  0, Sprite.SpellsBook
                SPRITE 17, 21,  0,  0, OR_XOR,  0, Sprite.Inventory
                SPRITE 19, 20,  0,  0, OR_XOR,  0, Sprite.Quest
                SPRITE 18, 20,  0,  0, OR_XOR,  0, Sprite.Map
                SPRITE 22, 23,  0,  0, OR_XOR,  0, Sprite.Options
Sprite:
.Diamond        incbin "small_diamond.bin"
.Character      incbin "character.bin"
.SpellsBook     incbin "spells_book.bin"
.Inventory      incbin "inventory.bin"
.Quest          incbin "quests.bin"
.Map            incbin "map.bin"
.Options        incbin "options.bin"
                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_
