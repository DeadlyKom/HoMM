
                ifndef _CODE_SUBMODULES_CONTOUR_PACK_
                define _CODE_SUBMODULES_CONTOUR_PACK_

                ; подготовка модуля для определения перемещаемых адресов
                MMU 3, PAGE_N
                ORG PASS * 0x100
                module Contour

                display "Submodules 'Contour':\t\t\t\t\t-------------------- [ ", /D, Size, " byte(s) ]\t\t\t[-]\t ------------------------"

                ; проверка прохода подготовки исходного кода
                if PASS != 2
Begin:          EQU $
                endif

                ; подключение содержимого модуля
                include "Source/Submodules/Contour/Include.inc"

                ; проверка прохода определения исходного размера
                if     PASS != 2
Size:           EQU $-Begin                                                     ; размер кода
                endif

                ; упаковка перемещаемого кода с дополнительной памятью
                COMPRESS_ASSET_CODE_MEMORY \
                Size.Work, \
                "Builder/Assets/Code/Original/Submodules/Contour/Contour.pack", \
                "Builder/Assets/Code/Compressed/Submodules.Contour.pack.ar"
                endmodule

                endif ; ~_CODE_SUBMODULES_CONTOUR_PACK_
