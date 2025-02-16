
                ifndef _BUILDER_LOADER_ERROR_MESSAGE_
                define _BUILDER_LOADER_ERROR_MESSAGE_
; -----------------------------------------
; отображение сообщения "нехватка оперативной памяти"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
InsufficientRAM ; -----------------------------------------
                ; отображение строки
                ; -----------------------------------------
                SCREEN_ADR_REG HL, MemBank_01_SCR, 7 << 3, 11 << 3
                LD (DrawChar.ScreenAdr), HL
                LD BC, .Message_1
                CALL .DrawString

                SCREEN_ADR_REG HL, MemBank_01_SCR, 2 << 3, 12 << 3
                LD (DrawChar.ScreenAdr), HL
                LD BC, .Message_2
                CALL .DrawString
                JR .Finish

.DrawString     ; отображение сообщения
.DrawStringLoop LD A, (BC)
                OR A
                RET Z

                INC BC
                CALL DrawChar
                JR .DrawStringLoop

.Finish         ; -----------------------------------------
                ; цикл бордюра
                ; -----------------------------------------
                
.Loop           LD A, R
                ADD A, A
                ADD A, A
                SBC A, A
                AND #07
                OUT (#FE), A
                LD B, #C2
                DJNZ $
                JR .Loop

.Message_1      BYTE "Insufficient RAM,\0"
.Message_2      BYTE "no further work is possible.\0"
ROM_FONT_ADR    EQU #3D00
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

                ; A *= 8
                ADD A, A
                ADD A, A
                RL D
                ADD A, A
                RL D

                ; сложение смещения и адреса
                LD E, A
                ADD HL, DE

                ; адрес экрана
.ScreenAdr      EQU $+1
                LD DE, #0000

                ; вывод на экран
                dup  7
                LD A, (DE)
                XOR (HL)
                LD (DE), A
                INC HL
                INC D
                edup
                LD A, (DE)
                XOR (HL)
                LD (DE), A

                ; переход к следующему знакоместу
                LD HL, .ScreenAdr
                INC (HL)

                RET
                display " - Insufficient RAM:\t\t\t\t\t\t\t= busy [ ", /D, $-InsufficientRAM, " byte(s) ]"

                endif ; ~_BUILDER_LOADER_ERROR_MESSAGE_
