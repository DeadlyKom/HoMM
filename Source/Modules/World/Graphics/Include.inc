
                ifndef _MODULE_WORLD_GRAPHICS_INCLUDE_
                define _MODULE_WORLD_GRAPHICS_INCLUDE_

                module Display
                include "Firmament.asm"
                include "Display_GameplayUI.asm"
                include "Display_DiamondChrono.asm"
                include "Display_GameplayFrame.asm"
                include "Display_DiamondTexture.asm"
                include "Display_GameplaySuspend.asm"
Icons           include "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/Icons.inc"
Pause           include "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/Pause.inc"
Frame           incbin "Builder/Assets/Graphics/Compressed/UI/GameWorld_Frame.pack"
Ornament        incbin "Builder/Assets/Graphics/Compressed/UI/GameWorld_Ornament.pack"
BigDiamond      incbin "Builder/Assets/Graphics/Compressed/UI/GameWorld_BigDiamond.pack"
Stencil         incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/stencil_diamond.mask.bin"
                endmodule

                endif ; ~_MODULE_WORLD_GRAPHICS_INCLUDE_
