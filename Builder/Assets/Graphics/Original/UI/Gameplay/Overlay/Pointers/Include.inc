
                ifndef _GRAPHICS_UI_GAMEPLAY_OVERLAY_POINTERS_INCLUDE_
                define _GRAPHICS_UI_GAMEPLAY_OVERLAY_POINTERS_INCLUDE_

                module Pointer
POINTER_VER     defl 1

SpriteInfo      ; -----------------------------------------
.Ox             EQU -0
.Oy             EQU -0
                if POINTER_VER = 0
                SPRITE  7,  6,  0+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._00
                SPRITE  7,  8,  0+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._01
                SPRITE  5, 10,  1+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._02
                SPRITE  7,  5,  0+SpriteInfo.Ox,  5+SpriteInfo.Oy, OR_XOR,  0, Sprite._03
                elseif POINTER_VER = 1
                SPRITE  7,  6,  8+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._10
                SPRITE  5,  8,  9+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._11
                SPRITE  7,  5,  8+SpriteInfo.Ox,  5+SpriteInfo.Oy, OR_XOR,  0, Sprite._12
                SPRITE  9,  5,  7+SpriteInfo.Ox,  5+SpriteInfo.Oy, OR_XOR,  0, Sprite._13
                elseif POINTER_VER = 2
                SPRITE  7,  6,  8+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._20
                SPRITE  5,  9,  9+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._21
                SPRITE 10,  4,  7+SpriteInfo.Ox,  6+SpriteInfo.Oy, OR_XOR,  0, Sprite._22
                SPRITE 10,  3,  7+SpriteInfo.Ox,  7+SpriteInfo.Oy, OR_XOR,  0, Sprite._23
                endif
                ; -----------------------------------------
Sprite:         if POINTER_VER = 0
._00            incbin "pointer_00.bin"
._01            incbin "pointer_01.bin"
._02            incbin "pointer_02.bin"
._03            incbin "pointer_03.bin"
                elseif POINTER_VER = 1
._10            incbin "pointer_10.bin"
._11            incbin "pointer_11.bin"
._12            incbin "pointer_12.bin"
._13            incbin "pointer_13.bin"
                elseif POINTER_VER = 2
._20            incbin "pointer_20.bin"
._21            incbin "pointer_21.bin"
._22            incbin "pointer_22.bin"
._23            incbin "pointer_23.bin"
                endif

                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_OVERLAY_POINTERS_INCLUDE_
