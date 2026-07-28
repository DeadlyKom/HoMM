
                ifndef _MODULE_PROGRESS_KERNEL_INCLUDE_
                define _MODULE_PROGRESS_KERNEL_INCLUDE_

                module Kernel
; минимальный размер буфера — #0217 байт (максимальный размер кода кадра)
TickBuffer      EQU #4000
; минимальный размер буфера — #036C байт (Graphics.UI.Progress.Strip.Size)
ProgressBuffer  EQU Adr.ExtraBuffer

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
