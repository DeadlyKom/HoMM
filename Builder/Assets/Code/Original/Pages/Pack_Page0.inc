
                ifndef _CODE_PAGE_0_PACK_
                define _CODE_PAGE_0_PACK_

                ; - компиляция модуля

                MMU 3, Page.Page0
                ORG Adr.Code.Page0
                module Page0

                display "\'Page 0\':\t\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[", /D, Page.Page0, "]\t ------------------------"
Begin:          EQU $

                include "Source/Memory/MemcpyTilemap.asm"
Size:           EQU $-Begin                                                     ; размер кода

                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Pages/Page0.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Pages/Page0.pack Builder/Assets/Code/Compressed/Page0.pack.ar"
                ; shellexec "Tools\Compressor\zx0.exe -f Builder/Assets/Code/Original/Pages/Page0.pack Builder/Assets/Code/Compressed/Page0.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Page0.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_PAGE_0_PACK_
