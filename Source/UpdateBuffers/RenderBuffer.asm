
                ifndef _UPDATE_BUFFERS_RENDER_
                define _UPDATE_BUFFERS_RENDER_
RENDER_BUFFER_COPY macro Offset?
                LD A, (HL)                                                      ; чтение метаданных карты (xFxxFFFx)
                AND C       ; 0F000000
                OR B        ; uF000000
                LD (Adr.RenderBuffer + (Offset?)), A
                endm
; -----------------------------------------
; обновление Render-буфера
; In:
; Out:
; Corrupt:
; Note:
;   * Tilemap-буфер копируется из тайловой карты на странице 1
;   * Render-буфер формируется для каждого тайла, где:
;
;          7    6    5    4    3    2    1    0
;       +----+----+----+----+----+----+----+----+
;       | HU | FG | .. | .. | .. | A2 | A1 | A0 |
;       +----+----+----+----+----+----+----+----+
;   
;       HU      [7]         - флаг, принудительного обновления гексагона (частично или полностью)
;       FG      [6]         - флаг, тумана (0 - гексагон закрашен туманом целиком)
;       ⚠️ два флага HU и FG позволяют управлять процесом смены видимого гексагона на невидимый ⚠️
;       A2-A0   [2-0]       - номер анимации гексагона (локальный)
;
;     - выставляется флаг HU (принудительного обновления гексагона)
;     - копируется флаг FG (тумана, 0 — гексагон закрашен туманом целиком)
;       из буфера метаданных карты
;     - номер анимации гексагона устанавливается в ноль,
;       в последующих шагах он будет модифицирован
;
;       * Render-буфер для каждого столбца гексагона выставляется флаг CU
;           необходимости обновить столбец гексагона (0 - обновление столбца не требуется)
;
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
RenderBuffer:
.LENGTH_LINE    EQU TILEMAP_WIDTH_DATA                                          ; длина линии 
.LINE_REPEAT    EQU TILEMAP_HEIGHT_DATA                                         ; количество повторений строки

                ; инициализация
                LD HL, Adr.MapMetadata
                LD A, (GameSession.MapSize.Width)
                SUB .LENGTH_LINE - 1
                LD E, A
                LD D, #00
                LD BC, (RENDER_FLAG_HEX_UPDATE << 8) | MAP_META_FOG_PLAYER_1_MASK

                ; копирование
.Offset         defl 0
                dup .LINE_REPEAT - 1
                ; -----------------------------------------
                dup .LENGTH_LINE - 1
                RENDER_BUFFER_COPY RenderBuffer.Offset
.Offset         = .Offset + 1
                INC HL
                edup
                RENDER_BUFFER_COPY RenderBuffer.Offset
.Offset         = .Offset + 1
                ; -----------------------------------------
                ADD HL, DE
                edup

                ; -----------------------------------------
                dup .LENGTH_LINE - 1
                RENDER_BUFFER_COPY RenderBuffer.Offset
.Offset         = .Offset + 1
                INC HL
                edup
                RENDER_BUFFER_COPY RenderBuffer.Offset
                ; -----------------------------------------

                ; блыор 1737 тактов для 6 копирований в ширину
                ; сократил с 6 до 5 ширину копирования,
                ; стало 1465 тактов, что позволит корректно работать с областью 5*8 = 40 байт!

                ; инициализация 22 * 8 стобов гексагона
                LD HL, Adr.RenderBuffer + 80 + 176
                LD DE, #0101
                JP SafeFill.b176

                display " - Update render buffer:\t\t\t\t", /A, RenderBuffer, "\t= busy [ ", /D, $-RenderBuffer, " byte(s)  ]"

                endif ; ~_UPDATE_BUFFERS_RENDER_
