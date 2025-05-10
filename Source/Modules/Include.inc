
                ifndef _MODULES_INCLUDE_
                define _MODULES_INCLUDE_

                ; список запускаемых модулей
                ; загружаются в общую память для запуска
                module Modules
Begin           EQU $
                include "Core/Execute.asm"
                include "World/Execute.asm"
                include "Session/Execute.asm"
                include "MainMenu/Execute.asm"
Size            EQU $-Begin
                display " - Modules:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                endmodule

                endif ; ~_MODULES_INCLUDE_
