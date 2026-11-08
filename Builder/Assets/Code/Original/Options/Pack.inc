
                ifndef _CODE_OPTIONS_PACK_
                define _CODE_OPTIONS_PACK_

                ; подготовка модуля для определения перемещаемых адресов
                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Options

                display "Module 'Options':\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"

                ; проверка прохода подготовки исходного кода
                if PASS != 2
Begin:          EQU $
                endif
                
                ; подключение содержимого модуля
                include "Source/Modules/Options/Include.inc"

                ; проверка прохода определения исходного размера
                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif
                
                ; упаковка перемещаемого кода
                COMPRESS_ASSET_CODE \
                "Builder/Assets/Code/Original/Options/Options.pack", \
                "Builder/Assets/Code/Compressed/Options.pack.ar"
                endmodule

                endif ; ~_CODE_OPTIONS_PACK_
