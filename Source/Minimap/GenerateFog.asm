
                ifndef _MINIMAP_GENERATE_FOG_
                define _MINIMAP_GENERATE_FOG_
FOG_BYTE        macro
                LD A, (DE)
                INC DE
                ADD A, A    ; F0 в 7 бите
                ADD A, A    ; F0 во флаге переполнения
                CCF         ; меняем флаг
                SBC A, A    ; если установлен значение 255 иначе 0
                
                RRC C           ; следующий бит
                AND C
                OR B
                LD B, A
                endm
FOG_BYTE_       macro
                LD A, (DE)
                INC DE
                ADD A, A    ; F0 в 7 бите
                ADD A, A    ; F0 во флаге переполнения
                CCF         ; меняем флаг
                SBC A, A    ; если установлен значение 255 иначе 0
                
                RRC C           ; следующий бит
                AND C
                OR B
                endm
; -----------------------------------------
; генерация тумана для миникарты
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GenerateFog:    ; инициализация
                LD DE, Adr.MapMetadata
                LD C, #01       ; вкл 1ой бит
                EXX
                LD DE, Adr.FogShadingBuf                                        ; результирующий буфер
                LD BC, (MAX_WORLD_HEX_Y << 8) | #01                             ; штриховка из двух байт

.Loop           EXX
                LD HL, .ContinueLoop
                PUSH HL

                ; формирование фикла одной строки 6 байт
                LD HL, FogByte
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
                JP (HL)
.ContinueLoop   EXX
                DJNZ .Loop
                RET
FogByte:        LD B, #00       ; аккумулирующее значение
                FOG_BYTE
                FOG_BYTE
                FOG_BYTE
                FOG_BYTE
                FOG_BYTE
                FOG_BYTE
                FOG_BYTE
                FOG_BYTE_

                EXX
                LD (DE), A
                INC DE
                EXX

                RET

                display " - Generate minimap fog:\t\t\t\t\t\t", /A, GenerateFog, "\t= busy [ ", /D, $-GenerateFog, " byte(s)  ]"

                endif ; ~_MINIMAP_GENERATE_FOG_
