
                ifndef _CODE_KERNEL_PACK_
                define _CODE_KERNEL_PACK_

                ; - компиляция модуля

                MMU 2, Page.Kernel
                ORG Adr.Kernel
                module Kernel

                display "\'Kernel\':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size, " byte(s) / free ", /D, #4000 - ($ - #8000 + Size), "]\t[", /D, Page.Kernel, "]\t ------------------------"
Begin:          EQU $

                DB #00
Size:           EQU $-Begin                                                     ; размер кода
                
                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Kernel/Kernel.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Kernel/Kernel.pack Builder/Assets/Code/Compressed/Kernel.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Kernel.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_KERNEL_PACK_
