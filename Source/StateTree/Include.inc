
                ifndef _STATE_TREE_INCLUDE_
                define _STATE_TREE_INCLUDE_

                module StateTree

                include "Initialize.asm"
                include "Possess.asm"
                include "Unpossess.asm"
                include "PlacementNew.asm"
                ; include "RemoveAtSwap.asm"
                include "RemoveAtSwapByIndex.asm"

                endmodule

                endif ; ~_STATE_TREE_INCLUDE_
