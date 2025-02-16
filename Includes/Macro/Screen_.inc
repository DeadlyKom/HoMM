
                ifndef _MACRO_SCREEN_
                define _MACRO_SCREEN_
; -----------------------------------------
; установка бордюра
; -----------------------------------------
BORDER          macro Color?
                LD A, Color?
                OUT (#FE), A
                endm
; -----------------------------------------
; корректировка адреса видимого экрана
; In:
; Out:
;   Reg? - старший байт адреса экрана
; Corrupt:
;   AF
; Note:
; -----------------------------------------
ADJUST_VISIBLE_SCR_ADR macro Reg?
                LD A, (Adr.Port_7FFD)
                AND SCREEN
                JR NZ, $+4
                RES 7, Reg?
                endm
; -----------------------------------------
; корректировка адреса скрытого экрана
; In:
; Out:
;   Reg? - старший байт адреса экрана
; Corrupt:
;   AF
; Note:
; -----------------------------------------
ADJUST_HIDDEN_SCR_ADR macro Reg?
                LD A, (Adr.Port_7FFD)
                AND SCREEN
                JR Z, $+4
                RES 7, Reg?
                endm
; -----------------------------------------
; расчёт адреса экрана в пикселях (x, y)
; и назначение еого рег. паре (Register)
; смещение ScreenAddress (#4000/#C000)
; -----------------------------------------
SCREEN_ADR_REG  macro Register?, ScreenAddress?, X?, Y?
                LD Register?, ScreenAddress? + ((((Y?) >> 3) & 0x18) << 8) + (((Y?) & 0x07) << 8) + (((Y?) & 0x38) << 2) + ((X?) >> 3)
                endm
SCREEN_ADR_DW   macro ScreenAddress?, X?, Y?
                DW ScreenAddress? + ((((Y?) >> 3) & 0x18) << 8) + (((Y?) & 0x07) << 8) + (((Y?) & 0x38) << 2) + ((X?) >> 3)
                endm
SCREEN_ATTR_ADR_REG  macro Register?, ScreenAddress?, X?, Y?
                LD Register?, (ScreenAddress?) | 0x1800 + ((((Y?) & 0x1F) << 5) + ((X?) & 0x1F))
                endm
SET_ATTR_IP     macro Inc?, Paper?
                LD (HL), ((0 << 7) | (0 << 6) | ((Paper?) << 3) | (Inc?))
                endm
SET_ATTR_IPB    macro Inc?, Paper?, Bright?
                LD (HL), ((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                endm
SET_ATTR_IPBF   macro Inc?, Paper?, Bright?, Flash?
                LD (HL), (((Flash?) << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                endm
SET_A_ATTR_IPB  macro Inc?, Paper?, Bright?
                LD A, (0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?)
                endm
SET_DE_ATTR_IPB macro Inc?, Paper?, Bright?
                LD DE, (((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?)) << 8) | ((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                endm
SET_REG_ATTR_IPB macro Register?, Inc?, Paper?, Bright?
                LD Register?, (0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?)
                endm
SET_REG_PAIR_ATTR_IPB macro Register?, Inc?, Paper?, Bright?
                LD Register?, (((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?)) << 8) | ((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                endm
; -----------------------------------------
; заполнение прямоугольника атрибутов (экранная область)
; адрес экрана ScreenAddress (#4000/#C000)
; по координатам (x, y) в знакоместах
; размерами (SizeX, SizeY) в знакоместах
; значением чернил (Inc), бумаги (Paper) и яркости (Bright)
; -----------------------------------------
ATTR_RECT_IPB   macro ScreenAddress?, X?, Y?, SizeX?, SizeY?, Inc?, Paper?, Bright?
.Address        EQU (ScreenAddress?) | 0x1800 + ((((Y?) & 0x1F) << 5) + ((X?) & 0x1F))
                LD DE, .Address
                LD C, SizeY?
.RowsLoop       LD H, D
                LD L, E
                LD B, SizeX?
.ColumnLoop     LD (HL), ((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                INC L
                DJNZ .ColumnLoop
                LD A, E
                ADD A, #20
                LD E, A
                ADC A, D
                SUB E
                LD D, A
                DEC C
                JR NZ, .RowsLoop
                endm
; -----------------------------------------
; заполнение 6144 байт (экранная область)
; адрес экрана ScreenAddress (#4000/#C000)
; значением Value
; -----------------------------------------
CLS             macro ScreenAddress?, Value?
                MEMSET_BYTE ScreenAddress?, Value?, ImageSize
                endm
JumpCLS         macro ScreenAddress?, Value?
                JP_MEMSET_BYTE ScreenAddress?, Value?, ImageSize
                endm
CLS_LDIR        macro ScreenAddress?, Value?
                SCREEN_ADR_REG HL, (ScreenAddress?) + 0, 0, 0
                SCREEN_ADR_REG DE, (ScreenAddress?) + 1, 0, 0
                LD BC, ImageSize-1
                LD (HL), Value?
                LDIR
                endm
; -----------------------------------------
; очистка прямоугольной области экрана
; In:
;   ScreenAddress? - адрес экрана
;   X?, Y?         - позиция в знакоместах
;   SizeX?         - ширина в знакоместах (кратная 2)
;   SizeY?         - высота в пикселях
;   Value?         - двухбайтное значение
; Out:
; Corrupt:
; Note:
;   если требуется очистить базовый экран, есть вероятность попасть стеком 
;   на адрес 0x4000 и запись при прерывании будет осуществлена в ПЗУ
; -----------------------------------------
CLS_RECT        macro ScreenAddress?, X?, Y?, SizeX?, SizeY?, Value?
                SCREEN_ADR_REG HL, (ScreenAddress?), ((X?) + (SizeX?)-1) << 3, ((((Y?)-1) << 3) + (SizeY?)) + 7
                RestoreDE
                LD (.ContainerSP), SP
                LD DE, Value?

.Loop           LD B, SizeY?
.RowLoop        LD SP, HL
                INC SP
                dup SizeX? >> 1                                                 ; SizeX? / 2
                PUSH DE
                edup

                ; классический метод "UP HL" 25/59
                LD A, H
                DEC H
                AND #07
                JP NZ, $+12
                LD A, L
                ADD A, #E0
                LD L, A
                SBC A, A
                AND #08
                ADD A, H
                LD H, A
                DJNZ .RowLoop

.ContainerSP    EQU $+1
                LD SP, #0000
                endm
; -----------------------------------------
; заполнение 768 байт (экранная область)
; адрес экрана ScreenAddress (#4000/#C000)
; значением чернил (Inc) и бумаги (Paper)
; -----------------------------------------
ATTR_IP         macro ScreenAddress?, Inc?, Paper?
                MEMSET_BYTE (ScreenAddress? + ImageSize), ((Paper?) << 3) | (Inc?), AttributeSize
                endm
JP_ATTR_IP      macro ScreenAddress?, Inc?, Paper?
                JP_MEMSET_BYTE (ScreenAddress? + ImageSize), ((Paper?) << 3) | (Inc?), AttributeSize
                endm
; -----------------------------------------
; заполнение 768 байт (экранная область)
; адрес экрана ScreenAddress (#4000/#C000)
; значением чернил (Inc), бумаги (Paper) и яркости (Bright)
; -----------------------------------------
ATTR_IPB        macro ScreenAddress?, Inc?, Paper?, Bright?
                MEMSET_BYTE (ScreenAddress? + ImageSize), (0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?), AttributeSize
                endm
JP_ATTR_IPB     macro ScreenAddress?, Inc?, Paper?, Bright?
                JP_MEMSET_BYTE (ScreenAddress? + ImageSize), (0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?), AttributeSize
                endm
ATTR_IPB_LDIR   macro ScreenAddress?, Inc?, Paper?, Bright?
                SCREEN_ATTR_ADR_REG HL, (ScreenAddress?) + 0, 0, 0
                SCREEN_ATTR_ADR_REG DE, (ScreenAddress?) + 1, 0, 0
                LD BC, AttributeSize-1
                SET_ATTR_IPB Inc?, Paper?, Bright?
                LDIR
                endm
; -----------------------------------------
; значением чернил (Inc), 
; бумаги (Paper), 
; яркости (Bright) и
; мерцание (Flash)
; -----------------------------------------
ZX_COLOR_IPBF   macro Inc?, Paper?, Bright?, Flash?
                DB (((Flash?) << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                endm
ZX_COLOR_IPB    macro Inc?, Paper?, Bright?
                DB ((0 << 7) | ((Bright?) << 6) | ((Paper?) << 3) | (Inc?))
                endm
ZX_COLOR_IP     macro Inc?, Paper?
                DB ((0 << 7) | (0 << 6) | ((Paper?) << 3) | (Inc?))
                endm

                endif ; ~_MACRO_SCREEN_
