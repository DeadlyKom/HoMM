
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
;   ℹ️ код расположен в странице 0
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
                ADD A, A    ; x8
                LD IXL, A
                LD IXH, HIGH Adr.CharacterArray >> 2
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
                ADD A, A    ; x8
                LD L, A
                LD H, HIGH Adr.CharacterArray >> 2
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32

                RET

                endif ; ~_CHARACTER_UTILITIES_CHARACTER_ADDRESS_
