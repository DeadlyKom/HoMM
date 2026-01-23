
                ifndef _MACRO_SPRITE_BLOCK_
                define _MACRO_SPRITE_BLOCK_
SPRITE_BLOCK    macro Width?, Height?, LocationX?, LocationY?, Flags?, Offset?
                FSpriteBlock {
                    Offset?-$-2,
                    {Width?, Height?},
                    {LocationX?, LocationY?},
                    Flags?
                }
                endm
                
                endif ; ~_MACRO_SPRITE_BLOCK_
