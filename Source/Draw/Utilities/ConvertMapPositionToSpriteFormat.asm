
                ifndef _DRAW_UTILS_CONVERT_MAP_POSITION_TO_SPRITE_FORMAT_
                define _DRAW_UTILS_CONVERT_MAP_POSITION_TO_SPRITE_FORMAT_

                module Utilities
; -----------------------------------------
; преобразовать положение на карте в формату спрайта
; In:
; Out:
;   HL - позиция по вертикали
;   DE - позиция по горизонтали
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
MapPosToSprFormat:
                ; расчёт положения карты по горизонтали
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)        ; положение в гексагонах (6)
                LD B, A
                ADD A, A    ; x2
                ADD A, B    ; x3
                LD B, A
                LD C, #00                                                       ; BC = X * 48 * 16 в формате 12.4

                ; расчёт смещения карты внутри гексагона в формате 12.4
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)          ; положение в знакоместах
                LD H, A
                LD L, C
                SRL H
                RR L
                ADD HL, BC
                LD (TransformToScr.MapPositionX), HL                            ; положения карты по горизонтали

                ; расчёт положения карты по вертикали
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)        ; положение в гексагонах (4)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD H, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)          ; положение в знакоместах
                INC A                                                           ; дополнительное смещение гексагона по вертикали
                ADD A, H
                LD L, #00
                LD H, A
                RR H
                RR L
                LD (TransformToScr.MapPositionY), HL                            ; положения карты по вертикали

                RET

                display " - Convert map position to sprite format:\t\t", /A, MapPosToSprFormat, "\t= busy [ ", /D, $ - MapPosToSprFormat, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_UTILS_CONVERT_MAP_POSITION_TO_SPRITE_FORMAT_
