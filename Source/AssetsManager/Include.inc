
                ifndef _ASSETS_MANAGER_INCLUDE_
                define _ASSETS_MANAGER_INCLUDE_

                module AssetsManager
Begin:          EQU $
                include "Core.asm"
                include "Load.asm"
                include "SelectDisk.asm"
                include "Mark.asm"
                include "MarkAsUnclaimed.asm"
                include "Release.asm"
                include "Allocation.asm"
                include "TryToFree.asm"
Size            EQU $-Begin
                display " - Assets manager: \t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                endmodule

                endif ; ~ _ASSETS_MANAGER_INCLUDE_
