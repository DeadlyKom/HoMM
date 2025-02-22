
                ifndef _KERNEL_MEMORY_PAGES_
                define _KERNEL_MEMORY_PAGES_
SetPage         EQU Bootloader.KernelMinimal.Memory.SetPage
SetPageStack    EQU Bootloader.KernelMinimal.Memory.SetPageStack
GetPage         EQU Bootloader.KernelMinimal.Memory.GetPage

                endif ; ~_KERNEL_MEMORY_PAGES_
