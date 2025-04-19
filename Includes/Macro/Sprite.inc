
                ifndef _MACRO_SPRITE_
                define _MACRO_SPRITE_
SPRITE_HL       macro Index?
                LD HL, Adr.SpriteInfoBuffer + Index? * FSprite
                endm
SPRITE_DE       macro Index?
                LD DE, Adr.SpriteInfoBuffer + Index? * FSprite
                endm
SPRITE_DW       macro Index?
                DW Adr.SpriteInfoBuffer + Index? * FSprite
                endm
SPRITE          macro Width?, Height?, SOx?, SOy?, Flags?, ExtraFlags?, Offset?
                FSprite {{Width?, Height?, SOx?, SOy?}, ExtraFlags?, Flags?, Offset?}
                endm
SPRITE_LINKER   macro SpriteNum?, Offset?
                FSpritesRef {SPRITE_REF | ((SpriteNum?) & 0x7F), 0, Offset?}
                endm
                
                endif ; ~_MACRO_SPRITE_
