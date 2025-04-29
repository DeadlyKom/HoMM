
                ifndef _SPRITE_INCLUDE_
                define _SPRITE_INCLUDE_

                module Sprite

                include "Initialize.asm"
                include "AddSprite.asm"
                include "FindGraphHeader.asm"
                include "FillSpriteIndices.asm"
EMPTY_INDEX     EQU #FF
BUFFER_ADDRESS  EQU Adr.TilemapBuffer
                endmodule
                
                endif ; ~_SPRITE_INCLUDE_
