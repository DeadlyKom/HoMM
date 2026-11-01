
                ifndef _KERNEL_STRING_
                define _KERNEL_STRING_
String:
.Copy               EQU Kernel.Utilities.String.Copy                            ; копирование строки
.Length             EQU Kernel.Utilities.String.GetLength                       ; длина строки
.GetStringID        EQU Kernel.Utilities.String.GetStringID                     ; получение адреса строки по индексу
.Draw.AutoPage      EQU Kernel.Utilities.String.DrawString.Page                 ; отображение строки с автоматическим копированием из страницы
.DrawColor.AutoPage EQU Kernel.Utilities.String.DrawColorString.Page            ; отображение цветной строки с автоматическим копированием из страницы

                endif ; ~_KERNEL_STRING_
