
                ifndef _HERO_UTILS_HERO_ADDRESS_
                define _HERO_UTILS_HERO_ADDRESS_
; -----------------------------------------
; получить адрес героя
; In:
;   A  - индекс героя
; Out:
;   IX - адрес героя
; Corrupt:
; Note:
; -----------------------------------------
Hero.Address.IX:; расчёт адреса распологаемого героя
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

                endif ; ~_HERO_UTILS_HERO_ADDRESS_
