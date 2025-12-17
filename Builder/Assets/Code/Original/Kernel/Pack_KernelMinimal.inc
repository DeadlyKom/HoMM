
                ifndef _CODE_KERNEL_MINIMAL_PACK_
                define _CODE_KERNEL_MINIMAL_PACK_

                MMU 2, Page.KernelMinimal
                module KernelMinimal
                DISP Adr.Interrupt

                display "'Kernel minimal':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[", /D, Page.KernelMinimal, "]\t ------------------------"
Begin:          EQU $

                ; interrupt
                include "Source/Interrupt/Include.inc"

                ; memory
                include "Source/Memory/Switch.asm"
                include "Source/Memory/MemSet.asm"
                include "Source/Memory/MemcpyFastLDIR.asm"

                ; utils
                include "Source/Draw/Utils/PixelAddress.asm"
                include "Source/Draw/Utils/PixelAttribute.asm"

                ; decompressor
                include "Source/Decompressor/Forward.asm"
                include "Source/Decompressor/Backward.asm"

                ; ToDo: перенести код в страницу "ассет менеджера",
                ;       функция Load, при загрузке переключает страницы, что вызывает UB
                ; assets manager
                include "Source/AssetsManager/Include.inc"
End:            EQU $
Size:           EQU End-Begin
                ENT
                endmodule

                endif ; ~ _CODE_KERNEL_MINIMAL_PACK_
