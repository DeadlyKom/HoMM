
                ifndef _TR_DOS_INCLUDE_
                define _TR_DOS_INCLUDE_

                module TRDOS
                DISP Adr.ExtraBuffer
ERR_WIN_PIX_X   EQU 2                                                           ; позиция изображения окна по горизонтали   (в знакоместах)
ERR_WIN_PIX_Y   EQU 72                                                          ; позиция изображения окна по вертикали     (в пикселях)
ERR_WIN_PIX_SX  EQU 28                                                          ; размер изображения окна по вертикали      (в знакоместах)
ERR_WIN_PIX_SY  EQU 40                                                          ; размер изображения окна по горизонтали    (в пикселях)
ERR_WIN_ATR_X   EQU 0                                                           ; позиция атрибутов окна по горизонтали     (в знакоместах)
ERR_WIN_ATR_Y   EQU 8                                                           ; позиция атрибутов окна по вертикали       (в знакоместах)
ERR_WIN_ATR_SX  EQU 32                                                          ; размер атрибутов окна по вертикали        (в знакоместах)
ERR_WIN_ATR_SY  EQU 8                                                           ; размер атрибутов окна по горизонтали      (в знакоместах)

ENABLE_IM2_BIT  EQU 0x00                                                        ; бит, включения прерывание IM2 по завершению работы с ПЗУ TR-DOS
ENABLE_IM2      EQU 1 << ENABLE_IM2_BIT                                         ; включить прерывание IM2 по завершению работы с ПЗУ TR-DOS
DISABLE_IM2     EQU 0 << ENABLE_IM2_BIT                                         ; выключить прерывание по завершению работы с ПЗУ TR-DOS
Begin:          EQU $
                include "Draw.asm"
                include "Error.asm"
                include "Window.asm"
                include "Jump3D12.asm"
                include "Initialize.asm"

                ; флаи работы с TR-DOS
Flags           DB DISABLE_IM2

Size            EQU $-Begin
                display " - TR-DOS:\t\t\t\t\t\t\t\t= busy [ ", /D, Size, " byte(s) ]"
                ENT
                endmodule

                endif ; ~ _TR_DOS_INCLUDE_
