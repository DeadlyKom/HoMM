
                ifndef _KERNEL_MEMORY_PAGES_
                define _KERNEL_MEMORY_PAGES_
SetPage         EQU Bootloader.KernelMinimal.Memory.SetPage
._5_bit         EQU Bootloader.KernelMinimal.Memory.SetPage._5_bit
.Extended       EQU Bootloader.KernelMinimal.Memory.SetPage.Extended
SetPageStack    EQU Bootloader.KernelMinimal.Memory.SetPageStack
GetPage         EQU Bootloader.KernelMinimal.Memory.GetPage

                endif ; ~_KERNEL_MEMORY_PAGES_
