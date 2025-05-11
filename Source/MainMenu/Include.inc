
                ifndef _MAIN_MENU_INCLUDE_
                define _MAIN_MENU_INCLUDE_

                module Base
                DISP Adr.MainMenu

                display "Shared code 'Main menu':\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.MainMenu, "]\t ------------------------"

                include "Loop.asm"
                include "Interrupt.asm"
                include "Core/Include.inc"
                include "Render/Include.inc"
Size            EQU $-Adr.MainMenu

                ENT
                endmodule

                endif ; ~_MAIN_MENU_INCLUDE_
