
                ifndef _MODULE_WORLD_GRAPHICS_INCLUDE_
                define _MODULE_WORLD_GRAPHICS_INCLUDE_

                module Display
                include "Display_GameWindow.asm"
Frame           incbin "Builder/Assets/Graphics/Original/UI/GameWorld_Frame.pack"
Ornament        incbin "Builder/Assets/Graphics/Original/UI/GameWorld_Ornament.pack"
                endmodule

                endif ; ~_MODULE_WORLD_GRAPHICS_INCLUDE_
