
                ifndef _BUFFERS_GET_GROUP_RECONNAISSANCE_BIT_NUMBER_
                define _BUFFERS_GET_GROUP_RECONNAISSANCE_BIT_NUMBER_
; -----------------------------------------
; получение номера бита разведки группы
; In:
;   A - номер группы
; Out:
;   C - номер бита разведки
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в странице 1
; -----------------------------------------
GetFogBit:      ; расчёт адреса номера бита в таблице групп
                ADD A, LOW .FogBitTable
                LD L, A
                ADC A, HIGH .FogBitTable
                SUB L
                LD H, A
                LD C, (HL)
                RET

.FogBitTable    DB MAP_META_FOG_PLAYER_1_BIT
                DB MAP_META_FOG_PLAYER_2_BIT
                DB MAP_META_FOG_PLAYER_3_BIT
                DB MAP_META_FOG_PLAYER_4_BIT

                display " - Get group reconnaissance bit number:\t\t", /A, GetFogBit, "\t= busy [ ", /D, $-GetFogBit, " byte(s)  ]"

                endif ; ~_BUFFERS_GET_GROUP_RECONNAISSANCE_BIT_NUMBER_