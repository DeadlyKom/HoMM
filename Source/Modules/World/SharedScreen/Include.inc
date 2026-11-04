
                ifndef _MODULE_WORLD_SHARED_SCREEN_INCLUDE_
                define _MODULE_WORLD_SHARED_SCREEN_INCLUDE_

                module SharedScreen
                DISP Adr.SharedScreen
                display "'World' code block 'shared screen':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedScreen, " byte(s) / free ", /D, Size.SharedScreen - Size, "]\t[7]\t ------------------------"

                include "Screen/Include.inc"
                include "Source/Cursor/Include.inc"                             ; код обновления логики курсора
                include "Effects/Include.inc"
Size            EQU $-Adr.SharedScreen

                ; проверка вместимости кода и состояния эффектов в выделенной области
                if Size > Size.SharedScreen
                error "World shared screen code size exceeded"
                endif
                ENT
                endmodule

                endif ; ~_MODULE_WORLD_SHARED_SCREEN_INCLUDE_
