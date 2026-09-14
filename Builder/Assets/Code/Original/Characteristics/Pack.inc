
                ifndef _CODE_CHARACTERISTICS_PACK_
                define _CODE_CHARACTERISTICS_PACK_

                ; подготовка модуля для определения перемещаемых адресов
                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Characteristics

                display "Module 'Characteristics':\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"

                ; проверка прохода подготовки исходного кода
                if PASS != 2
Begin:          EQU $
                endif

                ; подключение содержимого модуля
                include "Source/Modules/Characteristics/Include.inc"

                ; проверка прохода определения исходного размера
                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ; упаковка перемещаемого кода
                COMPRESS_ASSET_CODE \
                "Builder/Assets/Code/Original/Characteristics/Characteristics.pack", \
                "Builder/Assets/Code/Compressed/Characteristics.pack.ar"
                endmodule

                endif ; ~_CODE_CHARACTERISTICS_PACK_
