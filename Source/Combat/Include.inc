
                ifndef _COMBAT_INCLUDE_
                define _COMBAT_INCLUDE_

                module SharedCode
                DISP Adr.Combat

                display "Shared code 'Combat':\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Combat, "]\t ------------------------"

                include "Loop.asm"
                include "Release.asm"
                include "Interrupt.asm"
                include "UI/Include.inc"
                include "Render/Include.inc"
Size            EQU $-Adr.Combat

                ; проверка размещения общего кода
                if Size > Size.SharedPoint
                error "available size exceeded"
                endif

                ENT
                endmodule

                endif ; ~_COMBAT_INCLUDE_
