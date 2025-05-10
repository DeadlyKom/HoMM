
                ifndef _CODE_SESSION_PACK_
                define _CODE_SESSION_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Session

                display "Module 'Session':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"
Begin:          EQU $

                ; -----------------------------------------
                include "Source/Modules/Session/Include.inc"
                ; -----------------------------------------

                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ifdef _REBUILD

                ; -----------------------------------------
                if     PASS = 0
                savebin "Builder/Assets/Code/Original/Session/Session.pack.pass-1", Begin, Size

                ; -----------------------------------------
                elseif PASS = 1
                savebin "Builder/Assets/Code/Original/Session/Session.pack.pass-2", Begin, Size

                ; -----------------------------------------
                elseif PASS = 2

                ORG 0x0000
                include "Source/Functions/AdjustmentAddress.asm"                ; корректирование адресов (всегда первая)
                lua allpass
                MakeTransitionTable("Builder/Assets/Code/Original/Session/Session.pack.pass-1", "Builder/Assets/Code/Original/Session/Session.pack.pass-2")
                endlua
               
                incbin "Builder/Assets/Code/Original/Session/Session.pack.pass-1"
Size            EQU $                                                           ; фактический размер блока и корректировки адреса
                savebin "Builder/Assets/Code/Original/Session/Session.pack", 0, $
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Session/Session.pack Builder/Assets/Code/Compressed/Session.pack.ar"
                endif
                endif

                ; -----------------------------------------

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Session.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_SESSION_PACK_
