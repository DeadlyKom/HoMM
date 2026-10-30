
                ifndef _INVENTORY_INCLUDE_
                define _INVENTORY_INCLUDE_

                module SharedCode
                DISP Adr.Inventory

                display "Shared code 'Inventory':\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Inventory, "]\t ------------------------"

                include "Loop.asm"
                include "Release.asm"
                include "Interrupt.asm"
                include "UI/Include.inc"
                include "Render/Include.inc"
                include "Utilities/Include.inc"
Size            EQU $-Adr.Inventory

                ; проверка размещения общего кода инвентаря
                if Size > Size.SharedPoint
                error "available size exceeded"
                endif

                ENT
                endmodule

                endif ; ~_INVENTORY_INCLUDE_
