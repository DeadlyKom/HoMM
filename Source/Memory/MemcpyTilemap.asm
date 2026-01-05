
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
; -----------------------------------------
Tilemap:
.VISIBLE_X      EQU 6                                                           ; количество копируемых тайлов по горизонтали
.VISIBLE_Y      EQU 8                                                           ; количество копируемых тайлов по вертикали
                
                RES_VIEW_FLAG UPDATE_TILEMAP_RENDER_BUF_BIT                     ; сброс флага обновления Tilemap и Render буфера

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