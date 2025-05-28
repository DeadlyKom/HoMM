
                ifndef _HERO_UTILS_ADDRESS_HERO_
                define _HERO_UTILS_ADDRESS_HERO_
; -----------------------------------------
; получить адрес героя
; In:
;   A  - индекс героя
; Out:
;   IX - адрес героя
; Corrupt:
; Note:
; -----------------------------------------
Adr.IX:         ; расчёт адреса распологаемого героя
                ; IX = HERO_SIZE * индекс героя (64)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW Adr.HeroArray >> 3
                LD IXL, A
                ADC A, HIGH Adr.HeroArray >> 3
                SUB IXL
                LD IXH, A
                ADD IX, IX  ; x8
                ADD IX, IX  ; x16
                ADD IX, IX  ; x32

                RET

                endif ; ~_HERO_UTILS_ADDRESS_HERO_
