
                ifndef _MODULE_INVENTORY_GRAPHICS_INCLUDE_
                define _MODULE_INVENTORY_GRAPHICS_INCLUDE_

                module Display
                include "Display_Slots.asm"
                include "Display_Items.asm"
                include "Display_PaperDoll.asm"
                include "Display_Inventory.asm"
                include "Display_Description.asm"

                ifdef _DEBUG
                include "Display_DebugInfo.asm"
                endif

                include "DrawNotClippingComposite.asm"
                include "Builder/Assets/Graphics/Original/UI/Slots/Pack.inc"
                endmodule

                endif ; ~_MODULE_INVENTORY_GRAPHICS_INCLUDE_
