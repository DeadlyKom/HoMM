
                ifndef _KERNEL_SCREEN_
                define _KERNEL_SCREEN_
Screen:
.FromPageC000   EQU Bootloader.KernelMinimal.Memory.ScrFromPageC000             ; установка экрана расположенного в #C000
.SetPageBase    EQU Bootloader.KernelMinimal.Memory.ScrPageToC000               ; установка страницы видимого экрана
.SetPageShadow  EQU Bootloader.KernelMinimal.Memory.ScrPageToC000_              ; установка страницы скрытого экрана
.Swap           EQU Bootloader.KernelMinimal.Memory.SwapScreens                 ; смена экрана
.ShowBase       EQU Bootloader.KernelMinimal.Memory.ShowBaseScreen              ; отображение базового экрана
.ShowShadow     EQU Bootloader.KernelMinimal.Memory.ShowShadowScreen            ; отображение теневого экрана

                endif ; ~_KERNEL_SCREEN_
