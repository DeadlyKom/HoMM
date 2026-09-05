
                ifndef _MODULE_WORLD_GRAPHICS_INCLUDE_
                define _MODULE_WORLD_GRAPHICS_INCLUDE_

                module Display
                include "Display_GameplayUI.asm"
                include "Display_GameplayFrame.asm"
                include "Display_DiamondTexture.asm"
                include "Display_DiamondTest.asm"
Icons           include "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/Icons.inc"
Frame           incbin "Builder/Assets/Graphics/Compressed/UI/GameWorld_Frame.pack"
Ornament        incbin "Builder/Assets/Graphics/Compressed/UI/GameWorld_Ornament.pack"
BigDiamond      incbin "Builder/Assets/Graphics/Compressed/UI/GameWorld_BigDiamond.pack"
                endmodule

                endif ; ~_MODULE_WORLD_GRAPHICS_INCLUDE_
