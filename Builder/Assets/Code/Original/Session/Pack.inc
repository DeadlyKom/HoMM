
                ifndef _CODE_SESSION_PACK_
                define _CODE_SESSION_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG #0000
                module Session

                display "Module 'Session':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"
Begin:          EQU $

                ; -----------------------------------------
                ifdef _BUILD_MODULE_SESSION
                ; корректирование адресов (всегда первая)
                include "Source/Functions/AdjustmentAddress.asm"

                RELOCATE_START
                include "Source/Modules/Session/Include.inc"
                RELOCATE_END
RelocateTable   RELOCATE_TABLE
Size:           EQU $-Begin                                                     ; размер кода     
                
                savebin "Builder/Assets/Code/Original/Session/Session.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Session/Session.pack Builder/Assets/Code/Compressed/Session.pack.ar"
                ; -----------------------------------------
                else

                incbin "Builder/Assets/Code/Original/Session/Session.pack"
Size:           EQU $-Begin  
                endif
                ; -----------------------------------------

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Session.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_SESSION_PACK_
