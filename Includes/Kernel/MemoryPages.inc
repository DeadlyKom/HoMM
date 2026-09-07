
                ifndef _KERNEL_MEMORY_PAGES_
                define _KERNEL_MEMORY_PAGES_
SetPage         EQU Bootloader.KernelMinimal.Memory.SetPage                     ; установка страницы памяти в #C000
.ReadPort       EQU Bootloader.KernelMinimal.Memory.SetPage.ReadPort            ; повторное чтение копии порта #7FFD
.Pending        EQU Bootloader.KernelMinimal.Memory.SetPage.Pending             ; начало участка для повтора после прерывания
._5_bit         EQU Bootloader.KernelMinimal.Memory.SetPage._5_bit              ; адрес маски в инструкции AND
.Extended       EQU Bootloader.KernelMinimal.Memory.SetPage.Extended            ; конец участка для повтора, начало дополнительного кода
SetPageInStack  EQU Bootloader.KernelMinimal.Memory.SetPageInStack              ; установка страницы памяти по номеру из стека
GetPage         EQU Bootloader.KernelMinimal.Memory.GetPage                     ; получение номера текущей страницы памяти

                endif ; ~_KERNEL_MEMORY_PAGES_
