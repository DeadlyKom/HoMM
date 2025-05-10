
                ifndef _CODE_MAIN_MENU_PACK_
                define _CODE_MAIN_MENU_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG #0000
                module MainMenu

                display "Module 'MainMenu':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"
Begin:          EQU $

                ; -----------------------------------------
                ; корректирование адресов (всегда первая)
                include "Source/Functions/AdjustmentAddress.asm"

                RELOCATE_START
                include "Source/Modules/MainMenu/Include.inc"
                RELOCATE_END
RelocateTable   RELOCATE_TABLE
Size:           EQU $-Begin                                                     ; размер кода     
                
                savebin "Builder/Assets/Code/Original/MainMenu/MainMenu.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/MainMenu/MainMenu.pack Builder/Assets/Code/Compressed/MainMenu.pack.ar"
                ; -----------------------------------------

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/MainMenu.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_MAIN_MENU_PACK_
