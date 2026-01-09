
                ifndef _MODULE_WORLD_SCREEN_REFRESH_INCLUDE_
                define _MODULE_WORLD_SCREEN_REFRESH_INCLUDE_

                module ScreenRefresh
                DISP Adr.ScreenRefresh

                display "'World' code block 'screen refresh':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.ScreenRefresh, " byte(s) / free ", /D, Size.ScreenRefresh - Size, "]\t[7]\t ------------------------"

                include "HexagonUpdateAnalysis.asm"
                include "Source/Memory/MemcpyScreenBlock.asm"
Size            EQU $-Adr.ScreenRefresh

                ENT
                endmodule

                endif ; ~_MODULE_WORLD_SCREEN_REFRESH_INCLUDE_
