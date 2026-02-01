
                ifndef _MINIMAP_GENERATE_MAP_
                define _MINIMAP_GENERATE_MAP_
TEMPLATE_BYTE   macro
                LD A, (DE)
                INC DE
                LD L, A
                LD H, HIGH Adr.HexShadingTable  ; каждый тайл имеет свою штриховку
                EXX
                LD A, B         ; строка 1-8
                DEC A           ; -1
                AND C           ; маска
                EXX
                OR (HL)
                LD L, A
                LD H, HIGH Adr.HexShading       ; 8 байт штриховки
                
                RRC C           ; следующий бит
                LD A, C
                AND (HL)
                OR B
                LD B, A
                endm
TEMPLATE_BYTE_  macro
                LD A, (DE)
                INC DE
                LD L, A
                LD H, HIGH Adr.HexShadingTable  ; каждый тайл имеет свою штриховку
                EXX
                LD A, B         ; строка 1-8
                DEC A           ; -1
                AND C           ; маска
                EXX
                OR (HL)
                LD L, A
                LD H, HIGH Adr.HexShading       ; 8 байт штриховки
                
                RRC C           ; следующий бит
                LD A, C
                AND (HL)
                OR B
                endm
; -----------------------------------------
; генерация карты для миникарты
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GenerateMap:    ; инициализация
                LD DE, Adr.Hextile
                LD C, #01       ; вкл 1ой бит
                EXX
                LD DE, Adr.MapShadingBuf                                        ; результирующий буфер
                LD BC, (MAX_WORLD_HEX_Y << 8) | #01                             ; штриховка из двух байт

.Loop           EXX
                LD HL, .ContinueLoop
                PUSH HL

                ; формирование фикла одной строки 6 байт
                LD HL, TemplateByte
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
                JP (HL)
.ContinueLoop   EXX
                DJNZ .Loop
                RET
TemplateByte:   LD B, #00       ; аккумулирующее значение
                TEMPLATE_BYTE
                TEMPLATE_BYTE
                TEMPLATE_BYTE
                TEMPLATE_BYTE
                TEMPLATE_BYTE
                TEMPLATE_BYTE
                TEMPLATE_BYTE
                TEMPLATE_BYTE_

                EXX
                LD (DE), A
                INC DE
                EXX

                RET

                display " - Generate minimap map:\t\t\t\t\t\t", /A, GenerateMap, "\t= busy [ ", /D, $-GenerateMap, " byte(s)  ]"

                endif ; ~_MINIMAP_GENERATE_MAP_
