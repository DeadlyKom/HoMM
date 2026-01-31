
                ifndef _MODULE_WORLD_SHARED_SCREEN_INCLUDE_
                define _MODULE_WORLD_SHARED_SCREEN_INCLUDE_

                module SharedScreen
                DISP Adr.SharedScreen

                display "'World' code block 'shared screen':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedScreen, " byte(s) / free ", /D, Size.SharedScreen - Size, "]\t[7]\t ------------------------"

                include "Source/Cursor/Include.inc"                             ; код обновления логики курсора
Size            EQU $-Adr.SharedScreen

                ENT
                endmodule

                endif ; ~_MODULE_WORLD_SHARED_SCREEN_INCLUDE_
