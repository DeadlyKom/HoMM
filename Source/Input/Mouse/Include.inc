    
                ifndef _INPUT_MOUSE_INCLUDE_
                define _INPUT_MOUSE_INCLUDE_

                module Mouse
Begin:          EQU $

                include "Initialize.asm"
                include "CheckKeyState.asm"
                include "GetMouseCursorPosition.asm"
                include "UpdateCursor.asm"

                display "\t - Mouse:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"

                endmodule

                endif ; ~_INPUT_MOUSE_INCLUDE_
