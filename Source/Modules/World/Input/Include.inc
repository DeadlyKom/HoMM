
                ifndef _MODULE_WORLD_INPUT_INCLUDE_
                define _MODULE_WORLD_INPUT_INCLUDE_

                module Input
Input.Begin     EQU $
                include "Scan.asm"
                include "Input_Select.asm"
                include "Input_Movement.asm"
                include "Input_Accelerate.asm"
                display " - Input 'World':\t\t\t\t\t\t\t= busy [ ", /D, $-Input.Begin, " byte(s) ]"
                endmodule

                endif ; ~_MODULE_WORLD_INPUT_INCLUDE_
