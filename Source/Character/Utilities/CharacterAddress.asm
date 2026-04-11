
                ifndef _CHARACTER_UTILITIES_CHARACTER_ADDRESS_
                define _CHARACTER_UTILITIES_CHARACTER_ADDRESS_
; -----------------------------------------
; получить адрес персонажа
; In:
;   A  - индекс персонажа
; Out:
;   IX - адрес структуры персонажа (FCharacter)
; Corrupt:
;   AF, IX
; Note:
; -----------------------------------------
Character.Address.IX:; расчёт адреса распологаемого персонажа
                ; IX = CHARACTER_SIZE * индекс персонажа (64)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW Adr.CharacterArray >> 3
                LD IXL, A
                ADC A, HIGH Adr.CharacterArray >> 3
                SUB IXL
                LD IXH, A
                ADD IX, IX  ; x8
                ADD IX, IX  ; x16
                ADD IX, IX  ; x32

                RET

                endif ; ~_CHARACTER_UTILITIES_CHARACTER_ADDRESS_
