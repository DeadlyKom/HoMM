
                ifndef _MEMORY_COPY_TILEMAP_
                define _MEMORY_COPY_TILEMAP_

                module Memcpy
Begin:          EQU $
; -----------------------------------------
; копирование блока тайлов в рендер буфер
; In:
;   HL  - начальный адрес видимой части тайловой карты
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Tilemap:
.VISIBLE_X      EQU SCR_WORLD_SIZE_X                                            ; количество копируемых тайлов по горизонтали
.VISIBLE_Y      EQU SCR_WORLD_SIZE_Y + 1                                        ; количество копируемых тайлов по вертикали
                                                                                ; +1 т.к. тайл мб виден на половину
                                                                                ; видимая часть тайлов по горизонтали 11-11.5
                ; инициализация
                LD (.ContainerSP), SP
                LD A, (GameSession.MapSize.Width)
                LD E, A
                LD D, #00
                
                ; копирование VISIBLE_X * VISIBLE_Y байт тайлов
.Offset         defl 0
                dup .VISIBLE_Y
                LD SP, HL
                ; т.к. VISIBLE_X фиксированно и равно 12 байт, 
                ; код соответствет копированию строго 12 байт
                POP BC      ; +2
                POP AF      ; +4 
                EX AF, AF'
                POP AF      ; +6
                EXX
                POP HL      ; +8
                POP DE      ; +10
                POP BC      ; +12

                ; сохранение 12 байт
                LD SP, Adr.TilemapBuffer + .VISIBLE_X + .Offset
                PUSH BC
                PUSH DE
                PUSH HL
                EXX
                PUSH AF
                EX AF, AF'
                PUSH AF
                PUSH BC
                ADD HL, DE

.Offset         = .Offset + .VISIBLE_X
                edup
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

                display " - Memcpy tilemap:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"

                endmodule

                endif ; ~_MEMORY_COPY_TILEMAP_