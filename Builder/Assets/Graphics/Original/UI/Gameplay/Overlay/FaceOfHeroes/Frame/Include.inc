
                ifndef _GRAPHICS_UI_GAMEPLAY_OVERLAY_FACE_OF_HEROES_FRAME_INCLUDE_
                define _GRAPHICS_UI_GAMEPLAY_OVERLAY_FACE_OF_HEROES_FRAME_INCLUDE_

                module Frame
SpriteInfo      ; -----------------------------------------
                SPRITE 32, 32,  4,  4, OR_XOR,  0, Sprite._0
                ; -----------------------------------------
Sprite:         ;
._0             incbin "small_frame.bin"
                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_OVERLAY_FACE_OF_HEROES_FRAME_INCLUDE_
