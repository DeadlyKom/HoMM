
                ifndef _CORE_MODULE_UTILITIES_CHUNK_ARRAY_CORE_
                define _CORE_MODULE_UTILITIES_CHUNK_ARRAY_CORE_
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

GetChunkIndex:  JP Shift.RET
Shift:
                ; значение, определяющее размер чанка
                if CHUNK_SHIFT = 2
                ; -----------------------------------------
                ; CHUNK_SHIFT = 2
                ; -----------------------------------------
._48            ; 48x48 - (48 >> CHUNK_SHIFT) => 12x12 = 144 чанка
._64            ; 64x64 - (64 >> CHUNK_SHIFT) => 16х16 = 256 чанков
._80            ; 80x80 - (80 >> CHUNK_SHIFT) => 20x20 = 400 чанков
.RET            RET
                elseif CHUNK_SHIFT = 3

                ; -----------------------------------------
                ; CHUNK_SHIFT = 3
                ; -----------------------------------------
._48            ; 48x48 - (48 >> CHUNK_SHIFT) =>  6x6  = 36 чанка        
                LD A, D         ; %00YYYYYY
                RRA             ; %x00YYYYY
                AND %00011100   ; %000YYY00 x4
                LD D, A
                RRA             ; %0000YYY0 x2
                ADD A, D        ; x6
                LD D, A

                LD A, E         ; %00XXXXXX
                RRA             ; %000XXXXX
                RRA             ; %X000XXXX
                RRA             ; %XX000XXX
                AND %00000111   ; %00000XXX
                ADD A, D
                RET
                ; -----------------------------------------
._64            ; 64x64 - (64 >> CHUNK_SHIFT) =>  8х8  = 64 чанка
                LD A, E         ; %00XXXXXX
                RRA             ; %000XXXXX
                RRA             ; %X000XXXX
                RRA             ; %XX000XXX
                XOR D           ; %xxxxxxxx
                AND %00000111   ; %00000xxx
                XOR D           ; %00YYYXXX
                RET
                ; -----------------------------------------
._80            ; 80x80 - (80 >> CHUNK_SHIFT) => 10x10 = 100 чанков
                LD A, D         ; %0YYYYYYY
                RRA             ; %x0YYYYYY
                AND %00111100   ; %00YYYY00 x4
                LD D, A
                RRA             ; %000YYYY0 x2
                RRA             ; %0000YYYY x1
                ADD A, D        ; x5
                ADD A, A        ; x10
                LD D, A

                LD A, E         ; %0XXXXXXX
                RRA             ; %00XXXXXX
                RRA             ; %X00XXXXX
                RRA             ; %XX00XXXX
                AND %00001111   ; %0000XXXX
                ADD A, D
.RET            RET
                endif

                endif ; ~ _CORE_MODULE_UTILITIES_CHUNK_ARRAY_CORE_
