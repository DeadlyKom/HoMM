
                ifndef _KERNEL_CONSOLE_
                define _KERNEL_CONSOLE_
Console:
.DrawChar       EQU Kernel.Console.DrawChar
.DrawByte       EQU Kernel.Console.DrawByte
.DrawHalfByte   EQU Kernel.Console.DrawHalfByte
.DrawWord       EQU Kernel.Console.DrawWord
.DrawWordFrom   EQU Kernel.Console.DrawWordFromAdr
.DrawString     EQU Kernel.Console.DrawString
.StringLength   EQU Kernel.Console.StringLength
.SetCursor      EQU Kernel.Console.SetCursor
.SetScreenAdr   EQU Kernel.Console.SetScreenAdr
.SetAttribute   EQU Kernel.Console.SetAttribute
.SetDrawToOne   EQU Kernel.Console.SetDrawToOne
.SetDrawToTwo   EQU Kernel.Console.SetDrawToTwo

                endif ; ~_KERNEL_CONSOLE_
 