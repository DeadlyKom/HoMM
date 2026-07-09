
                ifndef _PARTICIPANT_UTILITIES_PARTICIPANT_ADDRESS_
                define _PARTICIPANT_UTILITIES_PARTICIPANT_ADDRESS_
; -----------------------------------------
; получить адрес участника
; In:
;   A  - индекс участника
; Out:
;   HL - адрес структуры персонажа (FCharacter)
; Corrupt:
;   AF, HL
; Note:
;   код расположен в странице 0
; -----------------------------------------
Participant.Address.HL:; расчёт адреса распологаемого участника

                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер структуры  равен 32 (PARTICIPANT_SIZE), чтобы получить индекс,
                ;   нужно сместить на 5 бита
                ; --------------------------------------------------------------
                if CHARACTER_SIZE > 32
                error "address calculation error"
                endif

                ; HL = PARTICIPANT_SIZE * индекс добовляемого игрока (8)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, A    ; x32
                LD L, A
                LD H, HIGH Adr.ParticipantArray
                RET
; -----------------------------------------
; получить адрес участника
; In:
;   A  - индекс участника
; Out:
;   IY - адрес структуры персонажа (FCharacter)
; Corrupt:
;   AF, IY
; Note:
;   код расположен в странице 0
; -----------------------------------------
Participant.Address.IY:; расчёт адреса распологаемого участника

                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер структуры  равен 32 (PARTICIPANT_SIZE), чтобы получить индекс,
                ;   нужно сместить на 5 бита
                ; --------------------------------------------------------------
                if CHARACTER_SIZE > 32
                error "address calculation error"
                endif

                ; IY = PARTICIPANT_SIZE * индекс добовляемого игрока (8)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, A    ; x32
                LD IYL, A
                LD IYH, HIGH Adr.ParticipantArray

                RET

                endif ; ~_PARTICIPANT_UTILITIES_PARTICIPANT_ADDRESS_
