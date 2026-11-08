
                ifndef _BATTLE_INCLUDE_
                define _BATTLE_INCLUDE_

                module SharedCode
                DISP Adr.Battle

                display "Shared code 'Battle':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Battle, "]\t ------------------------"

                include "Loop.asm"
                include "Release.asm"
                include "Interrupt.asm"
                include "UI/Include.inc"
                include "Render/Include.inc"
Size            EQU $-Adr.Battle

                ; проверка размещения общего кода
                if Size > Size.SharedPoint
                error "available size exceeded"
                endif

                ENT
                endmodule

                endif ; ~_BATTLE_INCLUDE_
