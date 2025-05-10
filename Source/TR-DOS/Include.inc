
                ifndef _TR_DOS_INCLUDE_
                define _TR_DOS_INCLUDE_

                module TRDOS
                DISP Adr.ExtraBuffer
Window:
.PosX           EQU 2                                                           ; позиция изображения окна по горизонтали   (в знакоместах)
.PosY           EQU 72                                                          ; позиция изображения окна по вертикали     (в пикселях)
.SizeX          EQU 28                                                          ; размер изображения окна по вертикали      (в знакоместах)
.SizeY          EQU 40                                                          ; размер изображения окна по горизонтали    (в пикселях)

Begin:          EQU $
Flags           DB DISABLE_IM2                                                  ; флаи работы с TR-DOS (0)

                include "Draw.asm"
                include "CheckError.asm"
                include "ErrorHandler.asm"
                include "Window.asm"
                include "Jump3D12.asm"
                include "Initialize.asm"
Buffer          DS 32, 0
Size            EQU $-Begin

                if Size > 1024
                error "превышен доступный размер"
                endif

                display " - TR-DOS:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                ENT
                endmodule

                endif ; ~ _TR_DOS_INCLUDE_
