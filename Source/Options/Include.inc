
                ifndef _OPTIONS_INCLUDE_
                define _OPTIONS_INCLUDE_

                module SharedCode
                DISP Adr.Options

                display "Shared code 'Options':\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Options, "]\t ------------------------"

                include "Loop.asm"
                include "Release.asm"
                include "Interrupt.asm"
                include "UI/Include.inc"
                include "Render/Include.inc"
Size            EQU $-Adr.Options

                ; проверка размещения общего кода
                if Size > Size.SharedPoint
                error "available size exceeded"
                endif

                ENT
                endmodule

                endif ; ~_OPTIONS_INCLUDE_
