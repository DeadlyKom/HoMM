
                ifndef _MODULE_WORLD_SCREEN_REFRESH_MEMORY_COPY_SCREEN_BLOCKS_
                define _MODULE_WORLD_SCREEN_REFRESH_MEMORY_COPY_SCREEN_BLOCKS_
; -----------------------------------------
; копирование screen block'и в теневой экран
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Memcpy:         LD HL, .Table
                LD DE, Adr.ScreenBlock
                LD A, #10

.Loop           EX AF, AF'
                LD A, (DE)
                OR A
                JR Z, .NextScrBlock

                XOR A
                LD (DE), A

                LD C, (HL)
                INC HL
                LD B, (HL)
                DEC HL
                PUSH BC

.NextScrBlock   INC HL
                INC HL
                INC E

                EX AF, AF'
                DEC A
                JR NZ, .Loop
                RET

.Table          DW Block_0, Block_4, Block_8, Block_C
                DW Block_1, Block_5, Block_9, Block_D
                DW Block_2, Block_6, Block_A, Block_E
                DW Block_3, Block_7, Block_B, Block_F

                ; -----------------------------------------
                ; копирование экранного блока шириной в 6 знакомест
                ; In:
                ;   HL  - начальный адрес
                ;   IXL - высота в знакоместах
                ; -----------------------------------------
Block_0         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*0 + 1) << 3, (6*0 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_1         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*1 + 1) << 3, (6*0 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_2         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*2 + 1) << 3, (6*0 + 1)<< 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_3         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*3 + 1) << 3, (6*0 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_4
Block_4         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*0 + 1) << 3, (6*1 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_5         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*1 + 1) << 3, (6*1 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_6         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*2 + 1) << 3, (6*1 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_7         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*3 + 1) << 3, (6*1 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_4
Block_8         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*0 + 1) << 3, (6*2 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_9         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*1 + 1) << 3, (6*2 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_A         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*2 + 1) << 3, (6*2 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_6
Block_B         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*3 + 1) << 3, (6*2 + 1) << 3
                LD IXL, #06
                JP Memcpy.Screen_4
Block_C         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*0 + 1) << 3, (6*3 + 1) << 3
                LD IXL, #04
                JP Memcpy.Screen_6
Block_D         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*1 + 1) << 3, (6*3 + 1) << 3
                LD IXL, #04
                JP Memcpy.Screen_6
Block_E         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*2 + 1) << 3, (6*3 + 1) << 3
                LD IXL, #04
                JP Memcpy.Screen_6
Block_F         SCREEN_ADR_REG HL, SCR_ADR_BASE, (6*3 + 1) << 3, (6*3 + 1) << 3
                LD IXL, #04
                JP Memcpy.Screen_4

                display " - Copy memory screen blocks to shadow screen:\t", /A, Memcpy, "\t= busy [ ", /D, $ - Memcpy, " byte(s)  ]"

                endif ; ~_MODULE_WORLD_SCREEN_REFRESH_MEMORY_COPY_SCREEN_BLOCKS_
