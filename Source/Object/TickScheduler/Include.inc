
                ifndef _OBJECT_TICK_SCHEDULER_INCLUDE_
                define _OBJECT_TICK_SCHEDULER_INCLUDE_

                module TickScheduler
Begin           EQU $
                include "Executor.asm"
                include "Initialize.asm"
                include "BuilderTwoPass.asm"
                include "TickObjectChunk.asm"

                display " - Object tick scheduler:\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_OBJECT_TICK_SCHEDULER_INCLUDE_
