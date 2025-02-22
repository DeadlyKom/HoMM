
                ifndef _KERNEL_INTERRUPT_
                define _KERNEL_INTERRUPT_
RestoreRegister EQU Bootloader.KernelMinimal.Interrupt.Handler.RestoreRegister
UserInterrupt   EQU Bootloader.KernelMinimal.Interrupt.Handler.UserInterrupt
Interrupt_RET   EQU Bootloader.KernelMinimal.Interrupt.Handler.RET
ReturnAddress   EQU Bootloader.KernelMinimal.Interrupt.Handler.ReturnAddress
TickCounterRef  EQU Bootloader.KernelMinimal.Interrupt.Handler.TickCounterPtr   ; счётчик тиков 1/50

                endif ; ~_KERNEL_INTERRUPT_
