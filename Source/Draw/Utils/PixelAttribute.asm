
                ifndef _DRAW_UTILS_PIXEL_ATTRIBUTE_
                define _DRAW_UTILS_PIXEL_ATTRIBUTE_

                module Utils
; -----------------------------------------
; расчёт экраного адреса атрибутов
; In:
;   DE - координаты D - y (в знакоместах), E - x (в знакоместах)
; Out:
;   DE - адрес экрана атрибутов
; Corrupt:
;   AF
; Note:
; -----------------------------------------
AttributeAdr:   LD A, D
                RRCA
                RRCA
                RRCA
                LD D, A
                XOR E
                AND %11100000
                XOR E
                LD E, A
                LD A, (GameState.Screen)
                OR D
                AND %11000011
                OR  %00011000
                LD D, A
                RET
; -----------------------------------------
; конверсия экраного адреса в адрес атрибутов
; In:
;   DE - адрес экрана
; Out:
;   DE - адрес экрана атрибутов
; Corrupt:
;   DE, AF
; Note:
; -----------------------------------------
PixelAttribute: LD A, D
                RRA
                RRA
                AND #06
                ADD A, #B0
                RL D
                RRA
                LD D, A
                RET
; -----------------------------------------
; конверсия экраного адреса атрибутов в адрес пикселей
; In:
;   DE - адрес экрана атрибутов
; Out:
;   DE - адрес экрана
; Corrupt:
;   DE, AF
; Note:
; -----------------------------------------
AttributePixel: LD A, D
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                XOR D
                AND %01111111
                XOR D
                LD D, A
                RET

                display " - Pixel attribute:\t\t\t\t\t", /A, PixelAttribute, "\t= busy [ ", /D, $ - PixelAttribute, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_UTILS_PIXEL_ATTRIBUTE_
