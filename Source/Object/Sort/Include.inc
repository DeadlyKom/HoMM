
                ifndef _OBJECT_SORT_INCLUDE_
                define _OBJECT_SORT_INCLUDE_

                module Sort
Begin           EQU $
                include "Prepare.asm"
                include "Sort.asm"
                include "Quicksort.asm"

                display " - Quick sort:\t\t\t\t\t", /A, Begin, " = busy [ ", /D, $-Begin, " byte(s)  ]"

                endmodule

                endif ; ~_OBJECT_SORT_INCLUDE_
