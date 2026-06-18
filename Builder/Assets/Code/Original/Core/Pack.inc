
                ifndef _CODE_CORE_PACK_
                define _CODE_CORE_PACK_

                ; - компиляция модуля

                MMU 2, Page.Kernel
                ORG Adr.Core
                module Core

                display "Shared code 'Core':\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Core, "]\t ------------------------"
Begin:          EQU $
                include "Source/Modules/Core/Include.inc"

                ; generator
                ; include "Source/TableGeneration/TG_PRNG.asm"                    ; пока отключена
                include "Source/TableGeneration/TG_ScrAdr.asm"
                include "Source/TableGeneration/TG_ByteMirror.asm"
                include "Source/TableGeneration/TG_ShiftTable.asm"
                include "Source/TableGeneration/TG_MultiplySpriteTable.asm"
Size:           EQU $-Begin                                                     ; размер кода
                COMPRESSED_ASSET \
                "Builder/Assets/Code/Original/Core/Core.pack", \
                "Builder/Assets/Code/Compressed/Core.pack.ar"
                endmodule

                endif ; ~ _CODE_CORE_PACK_
