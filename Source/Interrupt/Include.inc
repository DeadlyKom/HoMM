
                ifndef _INTERRUPT_INCLUDE_
                define _INTERRUPT_INCLUDE_

                module Interrupt
Begin:          EQU $
                include "Handler.asm"

                display " - Interrupt: \t\t\t\t\t", /A, Begin, " = busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~ _INTERRUPT_INCLUDE_
