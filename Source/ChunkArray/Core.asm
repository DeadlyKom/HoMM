
                ifndef _CORE_MODULE_UTILS_CHUNK_ARRAY_CORE_
                define _CORE_MODULE_UTILS_CHUNK_ARRAY_CORE_
; -----------------------------------------
; получение адреса указаннго чанка
; In:
;   A  - порядковый номер чанка
;   HL - адрес счётчиков массива чанков (выровненый 256 байт)
; Out:
;   HL - начальный адрес счётчиков в указанном чанке
;   A  - количествой пройденых элементов/начальный адрес расположения элементов
; Corrupt:
;   L, BC, AF
; Note:
; -----------------------------------------
GetAddress:     PUSH IY

                ; A = (255 - A) << 1 (обратный)
                CPL
                ADD A, A
                LD C, A
                LD B, #00
                LD A, B
                RL B

.Current        ; прирощение адреса перехода
                LD IY, .Rows
                ADD IY, BC
                JP (IY)

.Rows           rept 255
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
;   A  - порядковый номер чанка 
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
