
                ifndef _KERNEL_FPS_COUNTER_
                define _KERNEL_FPS_COUNTER_
FPS_Counter:
.Tick           EQU Kernel.FPS_Counter.Tick
.Frame          EQU Kernel.FPS_Counter.Frame
.Render         EQU Kernel.FPS_Counter.Render

                endif ; ~_KERNEL_FPS_COUNTER_
