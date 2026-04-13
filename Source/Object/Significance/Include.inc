
                ifndef _OBJECT_SIGNIFICANCE_INCLUDE_
                define _OBJECT_SIGNIFICANCE_INCLUDE_

                module Significance
Begin           EQU $
                include "Evaluate.asm"
                include "Handlers/Include.inc"
                include "Evaluators/Include.inc"

                display " - Object significance:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_TICK_SIGNIFICANCE_INCLUDE_
