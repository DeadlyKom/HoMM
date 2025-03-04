    
                ifndef _MODULE_INPUT_INCLUDE_
                define _MODULE_INPUT_INCLUDE_

                display " - Input: \t\t\t\t\t\t", /A, $, "\t= busy [ ", /D, Input.End - $, " byte(s)  ]"

                include "Keyboard/Include.inc"

                ifdef ENABLE_MOUSE
                include "Mouse/Include.inc"
                endif
                
                include "Kempston/Include.inc"

                module Input
Begin:          EQU $

                include "Input.asm"
                include "CheckKeyState.asm"

                display "\t - Cursor:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
End:            EQU $
                endmodule

                endif ; ~_MODULE_INPUT_INCLUDE_
