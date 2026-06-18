
                ifndef _CODE_PAGE_0_PACK_
                define _CODE_PAGE_0_PACK_

                ; - компиляция модуля

                MMU 3, Page.Page0
                ORG Adr.Code.Page0
                module Page0

                display "'Page 0':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.Code.Page0, " byte(s) / free ", /D, Size.Code.Page0 - Size, "]\t[", /D, Page.Page0, "]\t ------------------------"
Begin:          EQU $

                include "Source/Tick/Include.inc"
                include "Source/Object/Include.inc"
                include "Source/StateTree/Include.inc"
                include "Source/Character/Include.inc"
                include "Source/ChunkArray/Include.inc"
                include "Source/Participant/Include.inc"
Size:           EQU $-Begin                                                     ; размер кода
                if (Size.Code.Page0 - Size) < 0
                    error "allocated memory ran out!"
                endif
                COMPRESSED_ASSET \
                "Builder/Assets/Code/Original/Pages/Page0.pack", \
                "Builder/Assets/Code/Compressed/Page0.pack.ar"
                endmodule

                endif ; ~ _CODE_PAGE_0_PACK_
