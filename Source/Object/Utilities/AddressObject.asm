
                ifndef _HERO_UTILITIES_ADDRESS_OBJECT_
                define _HERO_UTILITIES_ADDRESS_OBJECT_
; -----------------------------------------
; получить адрес объекта
; In:
;   A  - индекс объекта
; Out:
;   IX - адрес объекта
; Corrupt:
;   HL, AF, IY
; Note:
; -----------------------------------------
Adr.IY:         ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                LD H, HIGH Adr.ObjectsArray >> 5    ; %00000110
                ADD A, A    ; %aaaaaaa0 : a
                RL H        ; %0000110a
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %000110aa
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %00110aaa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %0110aaaa
                ADD A, A    ; %aaa00000 : a
                RL H        ; %110aaaaa
                LD IYL, A
                LD A, H
                LD IYH, A
                RET

                endif ; ~_HERO_UTILITIES_ADDRESS_OBJECT_
