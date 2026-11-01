
                ifndef _MODULE_INVENTORY_INPUT_INCLUDE_
                define _MODULE_INVENTORY_INPUT_INCLUDE_

                module Input
                include "Scan.asm"
                include "Input_Exit.asm"
                include "Input_Select.asm"
                include "Input_Previous.asm"
                include "Input_Accelerate.asm"
                ifdef _DEBUG
                include "Input_Underlay.asm"
                endif
                endmodule

                endif ; ~_MODULE_INVENTORY_INPUT_INCLUDE_
