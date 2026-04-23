
                ifndef _OBJECT_UTILITIES_ADDRESS_OBJECT_
                define _OBJECT_UTILITIES_ADDRESS_OBJECT_
; -----------------------------------------
; получить адрес объекта
; In:
;   A  - индекс объекта
; Out:
;   IX - адрес объекта
; Corrupt:
;   HL, AF, IX
; Note:
; -----------------------------------------
Adr.IX:         ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                ; %0aaaaaaa
                LD H, HIGH Adr.ObjectsArray >> 4    ; %00001100
                ADD A, A    ; %aaaaaaa0 : 0
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %0001100a
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %001100aa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %01100aaa
                ADD A, A    ; %aaa00000 : a
                RL H        ; %1100aaaa

                LD IXL, A
                LD A, H
                LD IXH, A
                RET
; -----------------------------------------
; получить адрес объекта
; In:
;   A  - индекс объекта
; Out:
;   IY - адрес объекта
; Corrupt:
;   HL, AF, IY
; Note:
; -----------------------------------------
Adr.IY:         ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                ; %0aaaaaaa
                LD H, HIGH Adr.ObjectsArray >> 4    ; %00001100
                ADD A, A    ; %aaaaaaa0 : 0
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %0001100a
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %001100aa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %01100aaa
                ADD A, A    ; %aaa00000 : a
                RL H        ; %1100aaaa

                LD IYL, A
                LD A, H
                LD IYH, A
                RET

                endif ; ~_OBJECT_UTILITIES_ADDRESS_OBJECT_
