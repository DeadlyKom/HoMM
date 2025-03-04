
                ifndef _WORLD_LOCATION_INPUT_INCLUDE_
                define _WORLD_LOCATION_INPUT_INCLUDE_

                module Input
Input.Begin     EQU $
                include "Scan.asm"

                display " - Input :\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Input.Begin, " byte(s) ]"
                endmodule

                endif ; ~_WORLD_LOCATION_INPUT_INCLUDE_
