
                ifndef _KERNEL_CONVERT_
                define _KERNEL_CONVERT_
Convert:
.SetBaseScreen          EQU Kernel.Utils.SetBaseScreen                          ; установка работы с основным экраном
.SetShadowScreen        EQU Kernel.Utils.SetShadowScreen                        ; установка работы с теневым экраном
.DrawToVisibleScreen    EQU Kernel.Utils.DrawToVisibleScreen                    ; установка работы функций с видимым экраном
.DrawToHiddenScreen     EQU Kernel.Utils.DrawToHiddenScreen                     ; установка работы функций со скрытым экраном
.CharToScreen           EQU Kernel.Utils.PixelAddressC                          ; расчёт экраного адреса (в знакоместах)
.PixelToScreen          EQU Kernel.Utils.PixelAddressP                          ; расчёт экраного адреса (в пикселях)
.AttributeAdr           EQU Kernel.Utils.AttributeAdr                           ; расчёт экраного адреса атрибутов
.ToAttribute            EQU Kernel.Utils.PixelAttribute                         ; конверсия экраного адреса в адрес атрибутов
.ToPixel                EQU Kernel.Utils.AttributePixel                         ; конверсия экраного адреса атрибутов в адрес пикселей

                endif ; ~_KERNEL_CONVERT_
