
                ifndef _CODE_WORLD_PACK_
                define _CODE_WORLD_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG #0000
                module World

                display "Module 'World':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[", /D, Page.World, "]\t ------------------------"
Begin:          EQU $
                ; корректирование адресов (всехгда первая)
                include "Source/Functions/AdjustmentAddress.asm"

                RELOCATE_START
                include "Source/Modules/World/Include.inc"
                RELOCATE_END
RelocateTable   RELOCATE_TABLE
Size:           EQU $-Begin                                                     ; размер кода
                
                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/World/World.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/World/World.pack Builder/Assets/Code/Compressed/World.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/World.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_WORLD_PACK_
