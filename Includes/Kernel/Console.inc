
                ifndef _KERNEL_CONSOLE_
                define _KERNEL_CONSOLE_
Console:
.DrawChar       EQU Kernel.Console.DrawChar
.DrawByte       EQU Kernel.Console.DrawByte
.DrawHalfByte   EQU Kernel.Console.DrawHalfByte
.DrawWord       EQU Kernel.Console.DrawWord
.DrawWordFrom   EQU Kernel.Console.DrawWordFromAdr
.DrawString     EQU Kernel.Console.DrawString
.SetCursor      EQU Kernel.Console.SetCursor
.SetScreenAdr   EQU Kernel.Console.SetScreenAdr
.SetAttribute   EQU Kernel.Console.SetAttribute
.Attribute      EQU Kernel.Console.DrawChar.Attribute

                endif ; ~_KERNEL_CONSOLE_
 