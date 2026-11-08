
                ifndef _CODE_BATTLE_PACK_
                define _CODE_BATTLE_PACK_

                ; подготовка модуля для определения перемещаемых адресов
                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Battle

                display "Module 'Battle':\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"

                ; проверка прохода подготовки исходного кода
                if PASS != 2
Begin:          EQU $
                endif

                ; подключение содержимого модуля
                include "Source/Modules/Battle/Include.inc"

                ; проверка прохода определения исходного размера
                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ; упаковка перемещаемого кода
                COMPRESS_ASSET_CODE \
                "Builder/Assets/Code/Original/Battle/Battle.pack", \
                "Builder/Assets/Code/Compressed/Battle.pack.ar"
                endmodule

                endif ; ~_CODE_BATTLE_PACK_
