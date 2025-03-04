    
                ifndef _INPUT_KEMPSTON_INCLUDE_
                define _INPUT_KEMPSTON_INCLUDE_

                module Kempston
Begin:          EQU $
                include "CheckKeyState.asm"
                include "PressedKey.asm"
                include "Initialize.asm"

                display "\t - Kempston:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"

                endmodule

                endif ; ~_INPUT_KEMPSTON_INCLUDE_
