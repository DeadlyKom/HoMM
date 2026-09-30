
                ifndef _GRAPHICS_UI_CHARACTERISTICS_SCREEN_PAPER_DOLL_FEMALE_PACK_
                define _GRAPHICS_UI_CHARACTERISTICS_SCREEN_PAPER_DOLL_FEMALE_PACK_

                module PaperDoll
                module Female
                ORG #0000
Begin:          EQU $
                DB Graph.Num
Graph:          EQU $
                SPRITE_BLOCK  32,  32, 184,   8, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Head
                SPRITE_BLOCK  32,  48, 184,  40, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Breast
                SPRITE_BLOCK  24,  24, 160,  40, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Amulet
                SPRITE_BLOCK  24,  32, 216,  32, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.ShoulderPad
                SPRITE_BLOCK  32,  16, 184,  88, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Belt
                SPRITE_BLOCK  32,  40, 216,  72, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LeftHand
                SPRITE_BLOCK  16,   8, 216,  64, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LeftHand_
                SPRITE_BLOCK  32,  48, 152,  64, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.RightHand
                SPRITE_BLOCK  32,  32, 224, 112, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LeftRing
                SPRITE_BLOCK  32,  32, 144, 112, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.RightRing
                SPRITE_BLOCK   8,  16, 192, 104, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LowerBody_0
                SPRITE_BLOCK  48,  32, 176, 112, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LowerBody_1
                SPRITE_BLOCK   8,  24, 176, 144, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LowerBody_2
                SPRITE_BLOCK  16,   8, 168, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LowerBody_3
                SPRITE_BLOCK  16,  32, 216, 144, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LowerBody_4
                SPRITE_BLOCK  16,   8, 216, 176, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.LowerBody_5
                SPRITE_BLOCK  32,  32, 184, 144, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Boot
Graph.Num:      EQU ($-Graph) / FSpriteBlock
Sprite:
.Head           incbin "female_head.bin"
.Breast         incbin "female_breast.bin"
.Amulet         incbin "female_amulet.bin"
.ShoulderPad    incbin "female_shoulder_pad.bin"
.Belt           incbin "female_belt.bin"
.LeftHand       incbin "female_left_hand.bin"
.LeftHand_      incbin "female_left_hand_.bin"
.RightHand      incbin "female_right_hand.bin"
.LeftRing       incbin "female_left_ring.bin"
.RightRing      incbin "female_right_ring.bin"
.LowerBody_0    incbin "female_lower_body_0.bin"
.LowerBody_1    incbin "female_lower_body_1.bin"
.LowerBody_2    incbin "female_lower_body_2.bin"
.LowerBody_3    incbin "female_lower_body_3.bin"
.LowerBody_4    incbin "female_lower_body_4.bin"
.LowerBody_5    incbin "female_lower_body_5.bin"
.Boot           incbin "female_boot.bin"
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Original/UI/Characteristics/PaperDoll_Female.pack", \
                "Builder/Assets/Graphics/Compressed/UI/PaperDoll_Female.pack.ar"

                endmodule
                endmodule

                endif ; ~ _GRAPHICS_UI_CHARACTERISTICS_SCREEN_PAPER_DOLL_FEMALE_PACK_
