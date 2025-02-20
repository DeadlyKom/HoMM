
                ifndef _DRAW_UTILS_PIXEL_ADDRESS_
                define _DRAW_UTILS_PIXEL_ADDRESS_

                module Utils
; -----------------------------------------
; расчёт экраного адреса
; In:
;   DE - координаты D - y (в знакоместах), E - x (в знакоместах)
; Out:
;   DE - адрес экрана пикселей
; Corrupt:
;   AF
; Note:
; -----------------------------------------
PixelAddressC:  LD A, D
                RRCA
                RRCA
                RRCA
                AND #E0
                ADD A, E
                LD E, A
                LD A, (GameState.Screen)
                XOR D
                AND %11100000
                XOR D
                AND %11111000
                LD D, A
                RET
; -----------------------------------------
; расчёт экраного адреса
; In :
;   DE - координаты D - y (в пикселях), E - x (в пикселях)
; Out :
;   DE - адрес экрана (адресное пространство теневого экрана)
;   A  - номер бита (CPL)/ смещение от левого края
; Corrupt :
;   DE, AF, AF'
; Time :
;   128cc
; -----------------------------------------
PixelAddressP:  LD A, D
                RRA
                RRA
                RRA
                XOR D
                AND %00011000
                XOR D
                AND %00011111
                ; OR #C0
                EX AF, AF'
                LD A, D
                ADD A, A
                ADD A, A
                LD D, A
                LD A, E
                RRA
                RRA
                RRA
                XOR D
                AND %00011111
                XOR D
                EX AF, AF'
                LD D, A
                LD A, (GameState.Screen)
                OR D
                LD D, A
                LD A, E
                ; CPL
                AND %00000111
                EX AF, AF'
                LD E, A
                EX AF, AF'
                RET
; -----------------------------------------
; установка работы с экраном по адресу #4000
; In :
; Out :
; Corrupt :
;   AF
; -----------------------------------------
SetBaseScreen   LD A, #40
                LD (GameState.Screen), A
                RET
; -----------------------------------------
; установка работы с экраном по адресу #C000
; In :
; Out :
; Corrupt :
;   AF
; -----------------------------------------
SetShadowScreen LD A, #C0
                LD (GameState.Screen), A
                RET
; -----------------------------------------
; установка работы функций с видимым экраном
; In :
; Out :
; Corrupt :
;   AF
; -----------------------------------------
DrawToVisibleScreen LD A, (Adr.Port_7FFD)
                AND SCREEN
                LD A, #C0
                JR NZ, $+4
                LD A, #40
                LD (GameState.Screen), A
                RET
; -----------------------------------------
; установка работы функций со скрытым экраном
; In :
; Out :
; Corrupt :
;   AF
; -----------------------------------------
DrawToHiddenScreen LD A, (Adr.Port_7FFD)
                AND SCREEN
                LD A, #C0
                JR Z, $+4
                LD A, #40
                LD (GameState.Screen), A
                RET
 
                display " - Pixel address: \t\t\t\t\t", /A, PixelAddressC, " = busy [ ", /D, $ - PixelAddressC, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_UTILS_PIXEL_ADDRESS_
