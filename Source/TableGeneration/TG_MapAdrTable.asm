                ifndef _TABLE_GENERATION_MAP_ADDRESS_
                define _TABLE_GENERATION_MAP_ADDRESS_

                module Tables
; -----------------------------------------
; генерация адресов карты/методанных
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
TG_MapAdr:      LD HL, Adr.MapAdrTable
                LD A, (GameSession.MapSize.Width)
                LD C, A
                LD DE, #0000

                LD A, (GameSession.MapSize.Height)
                LD B, A

.Loop           ; адрес карты
                RES 6, L                    ; адреса для карты
                LD A, D
                ADD A, HIGH Adr.Hextile
                LD (HL), E
                SET 7, L
                LD (HL), A
                RES 7, L

                ; адрес метаданных
                SET 6, L                    ; адреса для методанных
                LD A, D
                ADD A, HIGH Adr.MapMetadata
                LD (HL), E
                SET 7, L
                LD (HL), A
                RES 7, L

                ; следующий адрес
                LD A, B
                EX AF, AF'
                EX DE, HL
                LD B, #00
                ADD HL, BC
                EX DE, HL
                EX AF, AF'
                LD B, A

                INC L
                DJNZ .Loop
                RET

                display " - Map address table generator:\t\t\t", /A, TG_MapAdr, "\t= busy [ ", /D, $-TG_MapAdr, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_MAP_ADDRESS_
