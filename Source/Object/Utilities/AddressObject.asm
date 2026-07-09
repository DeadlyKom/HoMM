
                ifndef _OBJECT_UTILITIES_ADDRESS_OBJECT_
                define _OBJECT_UTILITIES_ADDRESS_OBJECT_
; -----------------------------------------
; расчёт адрес объекта
; In:
;   A  - индекс объекта
; Out:
;   H:A - адрес объекта
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
CALC_OBJECT_ADD macro RegH?

                if OBJECT_SIZE > 32
                error "address calculation error"
                endif
                
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                ; %0aaaaaaa
                LD RegH?, HIGH Adr.ObjectsArray >> 4    ; %00001100
                ADD A, A    ; %aaaaaaa0 : 0
                ADD A, A    ; %aaaaaa00 : a
                RL RegH?    ; %0001100a
                ADD A, A    ; %aaaaa000 : a
                RL RegH?    ; %001100aa
                ADD A, A    ; %aaaa0000 : a
                RL RegH?    ; %01100aaa
                ADD A, A    ; %aaa00000 : a
                RL RegH?    ; %1100aaaa
                endm
; -----------------------------------------
; получить адрес объекта
; In:
;   A  - индекс объекта
; Out:
;   HL - адрес объекта
; Corrupt:
;   HL, AF, IX
; Note:
; -----------------------------------------
Adr.HL:         CALC_OBJECT_ADD H                                               ; расчёт адрес объекта
                LD L, A
                RET
; -----------------------------------------
; получить адрес объекта
; In:
;   A      - индекс объекта
; Out:
;   HL, IX - адрес объекта
; Corrupt:
;   HL, AF, IX
; Note:
; -----------------------------------------
Adr.IX:         CALC_OBJECT_ADD H                                               ; расчёт адрес объекта
                LD L, A
                LD IXL, A
                LD A, H
                LD IXH, A
                RET
; -----------------------------------------
; получить адрес объекта
; In:
;   A      - индекс объекта
; Out:
;   HL, IY - адрес объекта
; Corrupt:
;   HL, AF, IY
; Note:
; -----------------------------------------
Adr.IY:         CALC_OBJECT_ADD H                                               ; расчёт адрес объекта
                LD L, A
                LD IYL, A
                LD A, H
                LD IYH, A
                RET

                endif ; ~_OBJECT_UTILITIES_ADDRESS_OBJECT_
