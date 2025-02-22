
                ifndef _KERNEL_CONVERT_
                define _KERNEL_CONVERT_
Convert:
.SetBaseScreen          EQU Bootloader.KernelMinimal.Utils.SetBaseScreen        ; установка работы с основным экраном
.SetShadowScreen        EQU Bootloader.KernelMinimal.Utils.SetShadowScreen      ; установка работы с теневым экраном
.DrawToVisibleScreen    EQU Bootloader.KernelMinimal.Utils.DrawToVisibleScreen  ; установка работы функций с видимым экраном
.DrawToHiddenScreen     EQU Bootloader.KernelMinimal.Utils.DrawToHiddenScreen   ; установка работы функций со скрытым экраном
.CharToScreen           EQU Bootloader.KernelMinimal.Utils.PixelAddressC        ; расчёт экраного адреса (в знакоместах)
.PixelToScreen          EQU Bootloader.KernelMinimal.Utils.PixelAddressP        ; расчёт экраного адреса (в пикселях)
.AttributeAdr           EQU Bootloader.KernelMinimal.Utils.AttributeAdr         ; расчёт экраного адреса атрибутов
.ToAttribute            EQU Bootloader.KernelMinimal.Utils.PixelAttribute       ; конверсия экраного адреса в адрес атрибутов
.ToPixel                EQU Bootloader.KernelMinimal.Utils.AttributePixel       ; конверсия экраного адреса атрибутов в адрес пикселей

                endif ; ~_KERNEL_CONVERT_
