                ifndef _MODULE_INVENTORY_UTILITIES_INCLUDE_
                define _MODULE_INVENTORY_UTILITIES_INCLUDE_
                module Utilities
Buffer          EQU Adr.RenderBuffer                                            ; существующий временный буфер данных предметов

                include "Item.asm"
                include "Grid.asm"
                include "Equipment.asm"
                include "DraggedItem.asm"
                endmodule

                endif ; ~_MODULE_INVENTORY_UTILITIES_INCLUDE_
