
                ifndef _ASSETS_MANAGER_INCLUDE_
                define _ASSETS_MANAGER_INCLUDE_

                module AssetsManager
Begin:          EQU $
                include "Core.asm"
                include "Load.asm"
                include "Mark.asm"
                include "Release.asm"
                include "CheckFree.asm"
                include "TryToFree.asm"
                include "MemRelease.asm"
                include "Allocation.asm"
                include "SelectDisk.asm"
                include "FindFreeMem.asm"
                include "MemAllocation.asm"
                include "MarkAsUnclaimed.asm"
                include "FindInitialBlock.asm"
Size            EQU $-Begin
                display " - Assets manager: \t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                endmodule

                endif ; ~ _ASSETS_MANAGER_INCLUDE_
