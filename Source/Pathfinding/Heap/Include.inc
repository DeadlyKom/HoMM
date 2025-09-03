
                ifndef _PATHFINDING_HEAP_INCLUDE_
                define _PATHFINDING_HEAP_INCLUDE_

                module Heap                                                     ; min-heap, дочерние элементы всегда больше родительского

                include "Swap.inc"
                include "Insert.asm"
                include "Heapify.asm"
                include "Initialize.asm"

                endmodule

                endif ; ~ _PATHFINDING_HEAP_INCLUDE_
