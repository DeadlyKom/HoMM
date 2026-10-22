
                ifndef _MODULE_INVENTORY_SHARED_SCREEN_INCLUDE_
                define _MODULE_INVENTORY_SHARED_SCREEN_INCLUDE_

                module SharedScreen
                DISP Adr.SharedScreen
                display "'Inventory' code block 'shared screen':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedScreen, " byte(s) / free ", /D, Size.SharedScreen - Size, "]\t[7]\t ------------------------"

                include "Source/Memory/MemcpyScreenBound_Save.asm"
                include "Source/Memory/MemcpyScreenBound_Restore.asm"
                include "Source/Memory/MemcpyScreenAttributes_Fill.asm"
                include "Source/Memory/MemcpyScreenAttributes_Save.asm"
                include "Source/Memory/MemcpyScreenAttributes_Restore.asm"
Size            EQU $-Adr.SharedScreen
                ENT
                endmodule

                endif ; ~_MODULE_INVENTORY_SHARED_SCREEN_INCLUDE_
