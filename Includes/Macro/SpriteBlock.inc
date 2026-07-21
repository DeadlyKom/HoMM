
                ifndef _MACRO_SPRITE_BLOCK_
                define _MACRO_SPRITE_BLOCK_
SPRITE_BLOCK    macro Width?, Height?, LocationX?, LocationY?, Flags?, Offset?
                assert Width? >= 1 && Width? <= 256
                assert Height? >= 1 && Height? <= 192
                FSpriteBlock {
                    Offset?-$-2,
                    {Width? & 0xFF, Height? & 0xFF},
                    {LocationX?, LocationY?},
                    Flags?
                }
                endm
                
                endif ; ~_MACRO_SPRITE_BLOCK_
