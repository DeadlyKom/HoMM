
                ifndef _FPS_COUNTER_
                define _FPS_COUNTER_

                module FPS_Counter

                define FPS_X 30                                                 ; в знакоместах
                define FPS_Y 0 * 8                                              ; в пикселях
CURSOR_FPS      EQU SCR_ADR_SHADOW + /*Y*/ (((FPS_Y >> 3) & 0x18) << 8) + ((FPS_Y & 0x07) << 8) + ((FPS_Y & 0x38) << 2) + /*X*/FPS_X

                define FPS_INC WHITE
                define FPS_PAPER BLACK
                define FPS_BRIGHT 0
                define FPS_FLASH 0
COLOR_FPS       EQU ((FPS_FLASH << 7) | (FPS_BRIGHT << 6) | (FPS_PAPER << 3) | FPS_INC)

Begin           EQU $
; -----------------------------------------
; отсчёт прерываний
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Tick:           ;
.TicksCounter   EQU $+1
                LD A, #32
                DEC A
                CALL Z, .StoreFramerate
                LD (.TicksCounter), A
                RET

.StoreFramerate LD A, (Frame.FramesCounter)
                LD (Render.FPS), A
                XOR A
                LD (Frame.FramesCounter), A
                LD A, #32
                RET
; -----------------------------------------
; отсчёт готовности кадров
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Frame:  
.FramesCounter  EQU $+1
                LD A, #00
                ADD A, #01
                DAA
                LD (.FramesCounter), A
                RET
; -----------------------------------------
; отображение FPS
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Render:         ; установка атрибут
                LD A, COLOR_FPS
                CALL Console.SetAttribute
                
                ; установка позиции вывода
                LD HL, CURSOR_FPS
                CALL Console.SetScreenAdr

                ; отображение FPS
.FPS            EQU $+1
                LD A, #00
                JP Console.DrawByte

                display " - FPS_Counter: \t\t[DEBUG]\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_FPS_COUNTER_
