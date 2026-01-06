
                ifndef _MEMORY_COPY_TILEMAP_
                define _MEMORY_COPY_TILEMAP_

                module Memcpy
Begin:          EQU $
; -----------------------------------------
; копирование блока тайлов в рендер буфер
; In:
; Out:
; Corrupt:
; Note:
;   код расположен рядом с картой (страница 1)
;   854 такта
; -----------------------------------------
TilemapBuffer:
.VISIBLE_X      EQU TILEMAP_WIDTH_MEMCPY                                        ; количество копируемых тайлов по горизонтали
.VISIBLE_Y      EQU TILEMAP_HEIGHT_MEMCPY                                       ; количество копируемых тайлов по вертикали
                
                ; инициализация
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)             ; начальный адрес видимой части тайловой карты
                LD (.ContainerSP), SP
                LD A, (GameSession.MapSize.Width)
                LD E, A
                LD D, #00
                
                ; копирование VISIBLE_X * VISIBLE_Y байт тайлов
.Offset         defl 0
                dup .VISIBLE_Y
                LD SP, HL
                ; т.к. VISIBLE_X фиксированно и равно 6 байт, 
                ; код соответствет копированию строго 6 байт
                POP BC      ; +2
                POP AF      ; +4 
                EX AF, AF'
                POP AF      ; +6

                ; сохранение 6 байт
                LD SP, Adr.TilemapBuffer + .VISIBLE_X + .Offset
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