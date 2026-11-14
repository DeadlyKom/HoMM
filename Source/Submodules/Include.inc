                ifndef _SUBMODULES_INCLUDE_
                define _SUBMODULES_INCLUDE_

                ; список запускаемых сабмодулей
                ; загружаются в общую память для запуска
                module Submodules
Begin           EQU $
                include "Contour/Execute.asm"
Size            EQU $-Begin
                display " - Submodules:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                endmodule

                endif ; ~_SUBMODULES_INCLUDE_
