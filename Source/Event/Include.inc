
                ifndef _EVENT_INCLUDE_
                define _EVENT_INCLUDE_

                module Event
                include "Add.asm"
                include "Handler.asm"
                include "Lifetime_once.asm"
                include "Lifetime_timer.asm"
                include "Lifetime_condition.asm"
                include "Initialize.asm"
                include "PlacementNew.asm"
                include "RemoveAtSwap.asm"
                endmodule

                endif ; ~_EVENT_INCLUDE_
