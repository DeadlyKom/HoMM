
                ifndef _CODE_PAGE_3_PACK_
                define _CODE_PAGE_3_PACK_

                ; - компиляция модуля

                MMU 3, Page.Page3
                ORG Adr.Code.Page3
                module Page3

                display "'Page 3':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.Code.Page3, " byte(s) / free ", /D, Size.Code.Page3 - Size, "]\t[", /D, Page.Page3, "]\t ------------------------"
Begin:          EQU $

                include "Source/Pathfinding/Include.inc"
Size:           EQU $-Begin                                                     ; размер кода

                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Pages/Page3.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Pages/Page3.pack Builder/Assets/Code/Compressed/Page3.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Page3.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_PAGE_3_PACK_
