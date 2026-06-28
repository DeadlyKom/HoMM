
                ifndef _CODE_PAGE_4_PACK_
                define _CODE_PAGE_4_PACK_

                ; - компиляция модуля

                MMU 3, Page.Page4
                ORG Adr.Code.Page4
                module Page4

                display "'Page 4':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.Code.Page4, " byte(s) / free ", /D, Size.Code.Page4 - Size, "]\t[", /D, Page.Page4, "]\t ------------------------"
Begin:          EQU $

                include "Source/Player/Include.inc"
Size:           EQU $-Begin                                                     ; размер кода
                if (Size.Code.Page4 - Size) < 0
                    error "allocated memory ran out!"
                endif
                COMPRESSED_ASSET \
                "Builder/Assets/Code/Original/Pages/Page4.pack", \
                "Builder/Assets/Code/Compressed/Page4.pack.ar"
                endmodule

                endif ; ~ _CODE_PAGE_4_PACK_
