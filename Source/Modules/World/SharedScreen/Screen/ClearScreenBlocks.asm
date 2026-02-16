
                ifndef _MODULE_WORLD_SCREEN_REFRESH_CLEAR_SCREEN_BLOCKS_
                define _MODULE_WORLD_SCREEN_REFRESH_CLEAR_SCREEN_BLOCKS_
; -----------------------------------------
; очистка screen block'ов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ClearScrBlock:  LD HL, Adr.ScreenBlock
                LD D, H
                LD E, L
                INC E
                LD (HL), #00
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI
                LDI

                RET

                display " - Clear screen blocks:\t\t\t\t", /A, ClearScrBlock, "\t= busy [ ", /D, $ - ClearScrBlock, " byte(s)  ]"

                endif ; ~_MODULE_WORLD_SCREEN_REFRESH_CLEAR_SCREEN_BLOCKS_
