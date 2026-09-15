
                ifndef _CHARACTERISTICS_INCLUDE_
                define _CHARACTERISTICS_INCLUDE_

                module SharedCode
                DISP Adr.Characteristics

                display "Shared code 'Characteristics':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Characteristics, "]\t ------------------------"

                include "Loop.asm"
                include "Interrupt.asm"
                include "Release.asm"
                include "Render/Include.inc"
                include "UI/Include.inc"
Size            EQU $-Adr.Characteristics

                ENT
                endmodule

                endif ; ~_CHARACTERISTICS_INCLUDE_
