
                ifndef _TR_DOS_INCLUDE_
                define _TR_DOS_INCLUDE_

                module TRDOS
                DISP Adr.ExtraBuffer
ENABLE_IM2_BIT  EQU 0x00                                                        ; бит, включения прерывание IM2 по завершению работы с ПЗУ TR-DOS
ENABLE_IM2      EQU 1 << ENABLE_IM2_BIT                                         ; включить прерывание IM2 по завершению работы с ПЗУ TR-DOS
DISABLE_IM2     EQU 0 << ENABLE_IM2_BIT                                         ; выключить прерывание по завершению работы с ПЗУ TR-DOS

Window:
.PosX           EQU 2                                                           ; позиция изображения окна по горизонтали   (в знакоместах)
.PosY           EQU 72                                                          ; позиция изображения окна по вертикали     (в пикселях)
.SizeX          EQU 28                                                          ; размер изображения окна по вертикали      (в знакоместах)
.SizeY          EQU 40                                                          ; размер изображения окна по горизонтали    (в пикселях)

Begin:          EQU $
                include "Draw.asm"
                include "CheckError.asm"
                include "ErrorHandler.asm"
                include "Window.asm"
                include "Jump3D12.asm"
                include "Initialize.asm"

                ; флаи работы с TR-DOS
Flags           DB DISABLE_IM2
Buffer          DS 32, 0
Size            EQU $-Begin
                display " - TR-DOS:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                ENT
                endmodule

                endif ; ~ _TR_DOS_INCLUDE_
