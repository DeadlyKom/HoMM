
                ifndef _FUNCTIONS_INCLUDE_
                define _FUNCTIONS_INCLUDE_

                module Functions
Begin           EQU $
                include "JumpTable.asm"
                include "JumpPopPage.asm"
                ; include "ExecuteAssetCode.asm"

                display " - Functions:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_FUNCTIONS_INCLUDE_
