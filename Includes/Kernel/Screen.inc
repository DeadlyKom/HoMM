
                ifndef _KERNEL_SCREEN_
                define _KERNEL_SCREEN_
Screen:
.FromPageC000   EQU Kernel.Memory.ScrFromPageC000                               ; установка экрана расположенного в #C000
.SetPageBase    EQU Kernel.Memory.ScrPageToC000                                 ; установка страницы видимого экрана
.SetPageShadow  EQU Kernel.Memory.ScrPageToC000_                                ; установка страницы скрытого экрана
.Swap           EQU Kernel.Memory.SwapScreens                                   ; смена экрана
.ShowBase       EQU Kernel.Memory.ShowBaseScreen                                ; отображение базового экрана
.ShowShadow     EQU Kernel.Memory.ShowShadowScreen                              ; отображение теневого экрана

                endif ; ~_KERNEL_SCREEN_
