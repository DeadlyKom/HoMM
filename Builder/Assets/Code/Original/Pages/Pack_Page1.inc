
                ifndef _CODE_PAGE_1_PACK_
                define _CODE_PAGE_1_PACK_

                ; - компиляция модуля

                MMU 3, Page.Page1
                ORG Adr.Code.Page1
                module Page1

                display "\'Page 1\':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.Code.Page1, " byte(s) / free ", /D, Size.Code.Page1 - Size, "]\t[", /D, Page.Page1, "]\t ------------------------"
Begin:          EQU $

                include "Source/Memory/MemcpyTilemap.asm"
Size:           EQU $-Begin                                                     ; размер кода

                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Pages/Page1.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Pages/Page1.pack Builder/Assets/Code/Compressed/Page1.pack.ar"
                ; shellexec "Tools\Compressor\zx0.exe -f Builder/Assets/Code/Original/Pages/Page1.pack Builder/Assets/Code/Compressed/Page1.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Page1.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_PAGE_1_PACK_
