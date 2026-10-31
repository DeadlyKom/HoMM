
                ifndef _KERNEL_STRING_
                define _KERNEL_STRING_
String:
.Copy                   EQU Kernel.Utilities.String.Copy                        ; копирование строки
.Length                 EQU Kernel.Utilities.String.GetLength                   ; длина строки
.DrawString.AutoPage    EQU Kernel.Utilities.String.DrawString.Page             ; отображение строки с автоматическим копированием из страницы

                endif ; ~_KERNEL_STRING_
