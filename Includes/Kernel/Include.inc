
                ifndef _KERNEL_INCLUDE_
                define _KERNEL_INCLUDE_

                include "Render.inc"
                include "Screen.inc"
                include "Convert.inc"
                include "Interrupt.inc"
                include "MemoryPages.inc"

                ifdef SHOW_FPS | _DEBUG
                include "Console.inc"
                include "FPS_Counter.inc"
                endif

                endif ; ~_KERNEL_INCLUDE_
