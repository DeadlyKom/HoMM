
                ifndef _WORLD_INCLUDE_
                define _WORLD_INCLUDE_

                module SharedCode
                DISP Adr.World

                display "Shared code 'World':\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.World, "]\t ------------------------"

                include "Loop.asm"
                ; include "Release.asm"
                include "Interrupt.asm"
                include "Render/Include.inc"
                include "Tilemap/Include.inc"
                include "Source/World/UI/Include.inc"
Size            EQU $-Adr.World

                ; проверка размещения общего кода
                if Size > Size.SharedPoint
                error "available size exceeded"
                endif

                ENT
                endmodule

                endif ; ~_WORLD_INCLUDE_
