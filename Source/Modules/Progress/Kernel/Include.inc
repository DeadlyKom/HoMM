
                ifndef _MODULE_PROGRESS_KERNEL_INCLUDE_
                define _MODULE_PROGRESS_KERNEL_INCLUDE_

                module Kernel
                include "Tick.asm"
                include "Release.asm"
                include "HintText.inc"
                include "Initialize.asm"
                include "EnterProgress.asm"
Ornament        incbin "Builder/Assets/Graphics/Compressed/Progress/Ornament.pack"
Strip           incbin "Builder/Assets/Graphics/Compressed/Progress/Strip.pack"
WorldTreeSymbol incbin "Builder/Assets/Graphics/Compressed/Progress/WorldTreeSymbol.pack"
                endmodule

                endif ; ~_MODULE_PROGRESS_KERNEL_INCLUDE_
