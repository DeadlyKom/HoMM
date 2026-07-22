
                ifndef _FUNCTIONS_INCLUDE_
                define _FUNCTIONS_INCLUDE_

                module Functions
Begin           EQU $
                include "Delay.asm"
                include "Memcpy.asm"
                include "JumpTable.asm"
                include "CallUtils.asm"
                include "AssetUtils.asm"
                include "CopyScreen.asm"
                include "ClearScreen.asm"
                include "JumpPopPage.asm"

                display " - Functions:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_FUNCTIONS_INCLUDE_
