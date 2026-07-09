
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
;   код расположен в странице 0
; -----------------------------------------
Character.Address.IX:; расчёт адреса распологаемого персонажа

                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер структуры  равен 32 (CHARACTER_SIZE), чтобы получить индекс,
                ;   нужно сместить на 5 бита
                ; --------------------------------------------------------------
                if CHARACTER_SIZE > 32
                error "address calculation error"
                endif

                ; IX = CHARACTER_SIZE * CharacterID
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
; -----------------------------------------
; получить адрес персонажа
; In:
;   A  - индекс персонажа
; Out:
;   HL - адрес структуры персонажа (FCharacter)
; Corrupt:
;   AF, HL
; Note:
; -----------------------------------------
Character.Address.HL:; расчёт адреса размещаемого персонажа

                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер структуры  равен 32 (CHARACTER_SIZE), чтобы получить индекс,
                ;   нужно сместить на 5 бита
                ; --------------------------------------------------------------
                if CHARACTER_SIZE > 32
                error "address calculation error"
                endif

                ; HL = CHARACTER_SIZE * CharacterID
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW Adr.CharacterArray >> 3
                LD L, A
                ADC A, HIGH Adr.CharacterArray >> 3
                SUB L
                LD H, A
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32

                RET

                endif ; ~_CHARACTER_UTILITIES_CHARACTER_ADDRESS_
