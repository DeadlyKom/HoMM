
                ifndef _MODULE_PROGRESS_KERNEL_INCLUDE_
                define _MODULE_PROGRESS_KERNEL_INCLUDE_

                module Kernel
                include "Initialize.asm"
                include "EnterProgress.asm"
                include "Release.asm"
                include "HintText.inc"
Ornament        incbin "Builder/Assets/Graphics/Compressed/Progress/Ornament.pack"
Strip           incbin "Builder/Assets/Graphics/Compressed/Progress/Strip.pack"
                endmodule

                endif ; ~_MODULE_PROGRESS_KERNEL_INCLUDE_
