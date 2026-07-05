
                ifndef _KERNEL_CONVERT_
                define _KERNEL_CONVERT_
Convert:
.SetBaseScreen          EQU Bootloader.KernelMinimal.Utilities.SetBaseScreen        ; установка работы с основным экраном
.SetShadowScreen        EQU Bootloader.KernelMinimal.Utilities.SetShadowScreen      ; установка работы с теневым экраном
.DrawToVisibleScreen    EQU Bootloader.KernelMinimal.Utilities.DrawToVisibleScreen  ; установка работы функций с видимым экраном
.DrawToHiddenScreen     EQU Bootloader.KernelMinimal.Utilities.DrawToHiddenScreen   ; установка работы функций со скрытым экраном
.CharToScreen           EQU Bootloader.KernelMinimal.Utilities.PixelAddressC        ; расчёт экранного адреса (в знакоместах)
.PixelToScreen          EQU Bootloader.KernelMinimal.Utilities.PixelAddressP        ; расчёт экранного адреса (в пикселях)
.AttributeAdr           EQU Bootloader.KernelMinimal.Utilities.AttributeAdr         ; расчёт экранного адреса атрибутов
.ToAttribute            EQU Bootloader.KernelMinimal.Utilities.PixelAttribute       ; конверсия экранного адреса в адрес атрибутов
.ToPixel                EQU Bootloader.KernelMinimal.Utilities.AttributePixel       ; конверсия экранного адреса атрибутов в адрес пикселей
.MapPosToSprFormat      EQU Kernel.Utilities.MapPosToSprFormat                      ; преобразовать положение на карте в формату спрайта
.BinaryToDecimal.x8     EQU Kernel.Utilities.BinaryToDecimal.x8                     ; преобразование 8-битного числа в десятичную ASCII-строку
.BinaryToDecimal.x16    EQU Kernel.Utilities.BinaryToDecimal.x16                    ; преобразование 16-битного числа в десятичную ASCII-строку
.BinaryToDecimal.x24    EQU Kernel.Utilities.BinaryToDecimal.x24                    ; преобразование 24-битного числа в десятичную ASCII-строку
Utilities:
.SpriteBound            EQU Kernel.Utilities.SpriteBound                            ; получить ограничивающий прямоугольник спрайта
.TransformToScr         EQU Kernel.Utilities.TransformToScr                         ; преобразование положения объекта относительно экрана

                endif ; ~_KERNEL_CONVERT_
