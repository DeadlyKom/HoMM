
                ifndef _CODE_PAGE_3_PACK_
                define _CODE_PAGE_3_PACK_

                ; - компиляция модуля

                MMU 3, Page.Page3
                ORG Adr.Code.Page3
                module Page3

                display "'Page 3':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.Code.Page3, " byte(s) / free ", /D, Size.Code.Page3 - Size, "]\t[", /D, Page.Page3, "]\t ------------------------"
Begin:          EQU $

                DW #0000
Size:           EQU $-Begin                                                     ; размер кода
                if (Size.Code.Page3 - Size) < 0
                    error "allocated memory ran out!"
                endif
                COMPRESSED_ASSET \
                "Builder/Assets/Code/Original/Pages/Page3.pack", \
                "Builder/Assets/Code/Compressed/Page3.pack.ar"
                endmodule

                endif ; ~ _CODE_PAGE_3_PACK_
