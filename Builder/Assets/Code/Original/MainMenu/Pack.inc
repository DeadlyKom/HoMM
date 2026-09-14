
                ifndef _CODE_MAIN_MENU_PACK_
                define _CODE_MAIN_MENU_PACK_

                ; - компиляция модуля

                MMU 3, PAGE_N
                ORG PASS * 0x100
                module MainMenu

                display "Module 'MainMenu':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"

                ; проверка прохода для определения начала исходного кода
                if     PASS != 2
Begin:          EQU $
                endif

                ; -----------------------------------------
                include "Source/Modules/MainMenu/Include.inc"
                ; -----------------------------------------

                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ; формирование и сжатие перемещаемого пакета
                COMPRESS_ASSET_CODE \
                "Builder/Assets/Code/Original/MainMenu/MainMenu.pack", \
                "Builder/Assets/Code/Compressed/MainMenu.pack.ar"
                endmodule

                endif ; ~ _CODE_MAIN_MENU_PACK_
