
                ifndef _PLAYER_MUSIC_AY_INCLUDE_
                define _PLAYER_MUSIC_AY_INCLUDE_

                module AY
Release         EQU "7"
TonA	        EQU 0
TonB	        EQU 2
TonC	        EQU 4
Noise	        EQU 6
Mixer	        EQU 7
AmplA	        EQU 8
AmplB	        EQU 9
AmplC	        EQU 10
Env	            EQU 11
EnvTp	        EQU 13

Begin           EQU $
                include "PT3.asm"
Size            EQU $-Begin
                display " - PT3 Player:\t\t\t\t\t", /A, Begin, " = busy [ ", /D, Size, " bytes  ]"

                endmodule

                endif ; ~ _PLAYER_MUSIC_AY_INCLUDE_
