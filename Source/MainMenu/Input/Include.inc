
                ifndef _MAIN_MENU_INPUT_INCLUDE_
                define _MAIN_MENU_INPUT_INCLUDE_

                module Input
Input.Begin     EQU $
                include "Scan.asm"

                display " - Main input:\t\t\t\t\t", /A, Input.Begin, "\t= busy [ ", /D, $-Input.Begin, " byte(s)  ]"

                endmodule

                endif ; ~_MAIN_MENU_INPUT_INCLUDE_
