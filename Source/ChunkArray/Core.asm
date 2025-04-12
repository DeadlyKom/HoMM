
                ifndef _CORE_MODULE_UTILS_CHUNK_ARRAY_CORE_
                define _CORE_MODULE_UTILS_CHUNK_ARRAY_CORE_
; -----------------------------------------
; получение адреса указаннго чанка
; In:
;   A  - порядковый номер чанка [0..127]
;   HL - адрес массива чанков (выровненый 256 байт) + 0x80
; Out:
;   HL - начальный адрес счётчика в указанном чанке
;   A  - количествой пройденых элементов/начальный адрес расположения элементов
;   B  - обнулён
; Corrupt:
;   L, BC, AF
; Note:
; -----------------------------------------
GetAddress:     PUSH IY

                ; A = (127 - A) << 1 (обратный)
                CPL
                ADD A, A
                LD C, A

.Current        ; прирощение адреса перехода
                XOR A
                LD B, A
                LD IY, .Rows
                ADD IY, BC
                JP (IY)

.Rows           rept 127
                ADD A, (HL)
                INC L
                endr

                POP IY
                RET
; -----------------------------------------
; получение номера чанка
; In:
;   DE - координаты в тайлах (D - y, E - x)
; Out:
;   A  - порядковый номер чанка [0..127]
; Corrupt:
;   D, AF
; Note:
; -----------------------------------------
GetChunkIndex:  LD A, D
.Operation      EQU $
                NOP
                NOP
                LD D, A
                LD A, E
                RRA
                RRA
                RRA
                XOR D
.Mask           EQU $+1
                AND 0
                XOR D

                DEBUG_BREAK_POINT_M                                             ; произошла ошибка!

                RET

                endif ; ~ _CORE_MODULE_UTILS_CHUNK_ARRAY_CORE_
