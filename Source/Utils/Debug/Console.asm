
                ifndef _DEBUG_CONSOLE_
                define _DEBUG_CONSOLE_

                module Console
ROM_FONT_ADR    EQU #3D00
Begin           EQU $
; -----------------------------------------
; отображение символа
; In:
;   A  - ASCII номер символа
; Out:
; Corrupt:
;   HL, DE, AF
; Note:
; -----------------------------------------
DrawChar:       ; расчёт адреса символа
                LD HL, ROM_FONT_ADR - 0x100
                LD D, #00

                ; DA = A * 8
                ADD A, A    ; x2
                ADD A, A    ; x4
                RL D
                ADD A, A    ; x8
                RL D

                ; сложение смещения и адреса
                LD E, A
                ADD HL, DE

                ; адрес экрана
.ScreenAdr      EQU $+1
                LD DE, #0000

                ; проверка запрета смены экранов
                CHECK_RENDER_FLAG_A SWAP_DISABLE_BIT
                JR NZ, .SkipAdjust

                ADJUST_HIDDEN_SCR_ADR D                                         ; корректировка адреса скрытого экрана

.SkipAdjust		; вывод на экран
                dup  7
                LD A, (HL)
                LD (DE), A
                INC HL
                INC D
                edup
                LD A, (HL)
                LD (DE), A

                ; преобразование адреса пикселей в адрес атрибутов
                CALL Convert.ToAttribute
                EX DE, HL
.Attribute      EQU $+1
                LD (HL), #00

                ; переход к следующему знакоместу
                LD HL, .ScreenAdr
                INC (HL)

                RET
; -----------------------------------------
; отображение 8-битного значения
; In:
;   A  - 8-битное значение
; Out:
; Corrupt:
;   HL, DE, С, AF
; Note:
; -----------------------------------------
DrawByte:       LD B, A

                ; старший полубайт
                RRCA
                RRCA
                RRCA
                RRCA
                AND #0F

                CP #0A
                CCF
                ADC A, #30
                DAA
                CALL DrawChar
                LD A, B
DrawHalfByte:   ; младший полубайт
                AND #0F
                
                CP #0A
                CCF
                ADC A, #30
                DAA
                JP DrawChar
; -----------------------------------------
; отображение 16-битного значения
; In:
;   HL  - адрес 16-битного значения
; Out:
; Corrupt:
;   HL, DE, С, AF
; Note:
; -----------------------------------------
DrawWordFromAdr PUSH HL
                INC HL
                LD A, (HL)
                CALL DrawByte

                POP HL
                LD A, (HL)
                CALL DrawByte
                RET
; -----------------------------------------
; отображение 16-битного значения
; In:
;   BC  - 16-битное значение
; Out:
; Corrupt:
;   HL, DE, С, AF
; Note:
; -----------------------------------------
DrawWord:       LD A, B
                CALL DrawByte
                LD A, C
                JP DrawByte
; -----------------------------------------
; отображение строки
; In:
;   BC  - адрес строки
; Out:
; Corrupt:
;   HL, DE, С, AF
; Note:
; -----------------------------------------
DrawString:     LD A, (BC)
                OR A
                RET Z

                INC BC
                CALL DrawChar
                JR DrawString
; -----------------------------------------
; установка курсора вывода
; In:
;   DE - координаты в знакоместах (D - y, E - x)
; Out:
; Corrupt:
;   DE, AF
; Note:
; -----------------------------------------
SetCursor:      CALL Convert.CharToScreen
                LD (DrawChar.ScreenAdr), DE
                RET
; -----------------------------------------
; установка адреса вывода
; In:
;   HL - адрес экрана пикселей
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SetScreenAdr:   LD (DrawChar.ScreenAdr), HL
                RET
; -----------------------------------------
; установка атрибута вывода
; In:
;   A - атрибут вывода
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SetAttribute:   LD (DrawChar.Attribute), A
                RET

                display " - Console:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"

                endmodule

                endif ; ~_DEBUG_CONSOLE_
