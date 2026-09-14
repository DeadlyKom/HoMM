
                ifndef _CODE_PROGRESS_PACK_
                define _CODE_PROGRESS_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Progress

                display "Module 'Progress':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"
                ; проверка прохода для определения начала исходного кода
                if     PASS != 2
Begin:          EQU $
                endif

                ; -----------------------------------------
                include "Source/Modules/Progress/Include.inc"
                ; -----------------------------------------

                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ; формирование и сжатие перемещаемого пакета
                COMPRESS_ASSET_CODE \
                "Builder/Assets/Code/Original/Progress/Progress.pack", \
                "Builder/Assets/Code/Compressed/Progress.pack.ar"
                endmodule

                endif ; ~ _CODE_SESSION_PACK_
