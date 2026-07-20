
                ifndef _CODE_PROGRESS_PACK_
                define _CODE_PROGRESS_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Progress

                display "Module 'Progress':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"
Begin:          EQU $

                ; -----------------------------------------
                include "Source/Modules/Progress/Include.inc"
                ; -----------------------------------------

                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ifdef _REBUILD

                ; -----------------------------------------
                if     PASS = 0
                savebin "Builder/Assets/Code/Original/Progress/Progress.pack.pass-1", Begin, Size

                ; -----------------------------------------
                elseif PASS = 1
                savebin "Builder/Assets/Code/Original/Progress/Progress.pack.pass-2", Begin, Size

                ; -----------------------------------------
                elseif PASS = 2

                ORG 0x0000
                include "Source/Functions/AdjustmentAddress.asm"                ; корректирование адресов (всегда первая)
                lua allpass
                MakeTransitionTable("Builder/Assets/Code/Original/Progress/Progress.pack.pass-1", "Builder/Assets/Code/Original/Progress/Progress.pack.pass-2")
                endlua
               
                incbin "Builder/Assets/Code/Original/Progress/Progress.pack.pass-1"
Size            EQU $                                                           ; фактический размер блока и корректировки адреса
                savebin "Builder/Assets/Code/Original/Progress/Progress.pack", 0, $
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Progress/Progress.pack Builder/Assets/Code/Compressed/Progress.pack.ar"
                endif
                endif

                ; -----------------------------------------
                ASSETS_SIZE "Builder/Assets/Code/Compressed/Progress.pack.ar"
                endmodule

                endif ; ~ _CODE_SESSION_PACK_
