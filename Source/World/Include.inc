
                ifndef _WORLD_INCLUDE_
                define _WORLD_INCLUDE_

                module Base
                DISP Adr.World

                display "Shared code 'World':\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.World, "]\t ------------------------"

                include "Loop.asm"
                include "Interrupt.asm"
                include "Input/Include.inc"
                include "Event/Include.inc"
                include "Render/Include.inc"
                include "Tilemap/Include.inc"
                include "Source/World/UI/Layers.inc"
Size            EQU $-Adr.World

                ENT
                endmodule

                endif ; ~_WORLD_INCLUDE_
