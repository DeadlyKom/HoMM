
                ifndef _KERNEL_CONVERT_
                define _KERNEL_CONVERT_
Convert:
.SetBaseScreen          EQU Bootloader.KernelMinimal.Utilities.SetBaseScreen        ; установка работы с основным экраном
.SetShadowScreen        EQU Bootloader.KernelMinimal.Utilities.SetShadowScreen      ; установка работы с теневым экраном
.DrawToVisibleScreen    EQU Bootloader.KernelMinimal.Utilities.DrawToVisibleScreen  ; установка работы функций с видимым экраном
.DrawToHiddenScreen     EQU Bootloader.KernelMinimal.Utilities.DrawToHiddenScreen   ; установка работы функций со скрытым экраном
.CharToScreen           EQU Bootloader.KernelMinimal.Utilities.PixelAddressC        ; расчёт экраного адреса (в знакоместах)
.PixelToScreen          EQU Bootloader.KernelMinimal.Utilities.PixelAddressP        ; расчёт экраного адреса (в пикселях)
.AttributeAdr           EQU Bootloader.KernelMinimal.Utilities.AttributeAdr         ; расчёт экраного адреса атрибутов
.ToAttribute            EQU Bootloader.KernelMinimal.Utilities.PixelAttribute       ; конверсия экраного адреса в адрес атрибутов
.ToPixel                EQU Bootloader.KernelMinimal.Utilities.AttributePixel       ; конверсия экраного адреса атрибутов в адрес пикселей
.MapPosToSprFormat      EQU Kernel.Utilities.MapPosToSprFormat                      ; преобразовать положение на карте в формату спрайта
Utilities:
.SpriteBound            EQU Kernel.Utilities.SpriteBound                            ; получить ограничивающий прямоугольник спрайта
.TransformToScr         EQU Kernel.Utilities.TransformToScr                         ; преобразование положения объекта относительно экрана

                endif ; ~_KERNEL_CONVERT_
