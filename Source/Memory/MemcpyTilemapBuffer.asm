
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
.POP_PUSH_LINE  EQU 6                                                           ; длина линии POP & PUSH
.LINE_REPEAT    EQU TILEMAP_HEIGHT_DATA                                         ; количество повторений строки
                
                ; инициализация
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)             ; начальный адрес видимой части тайловой карты
                LD (.ContainerSP), SP
                LD A, (GameSession.MapSize.Width)
                LD E, A
                LD D, #00
                
                ; копирование POP_PUSH_LINE * LINE_REPEAT байт тайлов
.Offset         defl 0
                dup .LINE_REPEAT-1
                LD SP, HL
                ; т.к. POP_PUSH_LINE фиксированно и равно 6 байт, 
                ; код соответствет копированию строго 6 байт
                POP BC      ; +2
                POP AF      ; +4 
                EX AF, AF'
                POP AF      ; +6

                ; сохранение 6 байт
                LD SP, Adr.TilemapBuffer + .POP_PUSH_LINE + .Offset
                PUSH AF     ; -6
                EX AF, AF'
                PUSH AF     ; -4
                PUSH BC     ; -2
                ADD HL, DE
.Offset         = .Offset + .POP_PUSH_LINE - (.POP_PUSH_LINE - TILEMAP_WIDTH_DATA)
                edup

                LD SP, HL
                ; т.к. POP_PUSH_LINE фиксированно и равно 6 байт, 
                ; код соответствет копированию строго 6 байт
                POP BC      ; +2
                POP AF      ; +4 
                EX AF, AF'
                POP DE      ; +6

                ; портит 1 байт #BB28, его пропускаем
                LD HL, Adr.TilemapBuffer + .POP_PUSH_LINE + .Offset-2
                LD (HL), E
                ; сохранение 6 байт
                LD SP, HL
                EX AF, AF'
                PUSH AF     ; -4
                PUSH BC     ; -2


.ContainerSP    EQU $+1
                LD SP, #0000

                RET

                display " - Memcpy tilemap:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MEMORY_COPY_TILEMAP_