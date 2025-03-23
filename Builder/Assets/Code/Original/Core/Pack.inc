
                ifndef _CODE_CORE_PACK_
                define _CODE_CORE_PACK_

                ; - компиляция модуля

                MMU 2, Page.Kernel
                ORG Adr.Core
                module Core

                display "\'Core\':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Core, "]\t ------------------------"
Begin:          EQU $
                include "Source/Modules/Core/Include.inc"

                ; generator
                include "Source/TableGeneration/TG_PRNG.asm"
                include "Source/TableGeneration/TG_ScrAdr.asm"
                include "Source/TableGeneration/TG_ByteMirror.asm"
                include "Source/TableGeneration/TG_ShiftTable.asm"
                include "Source/TableGeneration/TG_MultiplySpriteTable.asm"
Size:           EQU $-Begin                                                     ; размер кода
                
                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Core/Core.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Core/Core.pack Builder/Assets/Code/Compressed/Core.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Core.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_CORE_PACK_
