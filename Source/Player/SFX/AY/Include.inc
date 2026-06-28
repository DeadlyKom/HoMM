
                ifndef _PLAYER_SFX_AY_INCLUDE_
                define _PLAYER_SFX_AY_INCLUDE_
; -----------------------------------------
; взят за основу ayFX player v2.04
; https://github.com/Threetwosevensixseven/ayfxedit-improved
;
; Note:
;   ограничение по длине эффекта не более 255 фреймов (прерываний)
;   структура должна хранения проигрываемых эффектов расположена в блоке 256 байт
; -----------------------------------------

                module AY
AFX_CHANGE_NOISE_BIT    EQU 0x06
AFX_CHANGE_TONE_BIT     EQU 0x05
AFX_VOLUME_MASK         EQU %00001111

                struct FChannelAY
EffectAdr       FAddress                                                        ; текущий адрес проигрывания эффекта (если канал свободен, старший байт равен 0x00)
EffectTime      DB #00                                                          ; время проигрывания эффекта

                ends

                struct FAFX
A               FChannelAY
B               FChannelAY
C               FChannelAY
                ends
                display " - SFX AY: \t\t\t\t\t\t", /A, Begin, " = busy [ ", /D, Size, " bytes  ]"
Begin           EQU $

                include "Initialize.asm"
                include "Tick.asm"
                include "Play.asm"
AFX_Variables   FAFX

                if (AFX_Variables >> 8) - ($ >> 8)
                error "must be within single 256 byte block"
                endif
Size            EQU $-Begin

                endmodule

                endif ; ~ _PLAYER_SFX_AY_INCLUDE_
