
                ifndef _TILEMAP_UPDATE_BUFFERS_
                define _TILEMAP_UPDATE_BUFFERS_

RENDER_BUFFER_COPY macro Offset?
                LD A, (HL)                                                      ; чтение метаданных карты (xFxxFFFx)
                AND C       ; 0F000000
                OR B        ; uF000000
                LD (Adr.RenderBuffer + (Offset?)), A
                endm
; -----------------------------------------
; обновление Tilemap- и Render-буферов
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
UpdateBuffers:  RES_VIEW_FLAG UPDATE_TILEMAP_RENDER_BUF_BIT                     ; сброс флага обновления Tilemap и Render буфера

                ; инициализация
                LD HL, Adr.MapMetadata
                LD A, (GameSession.MapSize.Width)
                SUB TILEMAP_WIDTH_MEMCPY-1
                LD E, A
                LD D, #00
                LD BC, (RENDER_FLAG_HEX_UPDATE << 8) | MAP_META_FOG_PLAYER_1_MASK

                ; копирование
.Offset         defl 0
                dup TILEMAP_HEIGHT_MEMCPY - 1
                ; -----------------------------------------
                dup TILEMAP_WIDTH_MEMCPY - 1
                RENDER_BUFFER_COPY UpdateBuffers.Offset
.Offset         = .Offset + 1
                INC HL
                edup
                RENDER_BUFFER_COPY UpdateBuffers.Offset
.Offset         = .Offset + 1
                ; -----------------------------------------
                ADD HL, DE
                edup

                ; -----------------------------------------
                dup TILEMAP_WIDTH_MEMCPY - 1
                RENDER_BUFFER_COPY UpdateBuffers.Offset
.Offset         = .Offset + 1
                INC HL
                edup
                RENDER_BUFFER_COPY UpdateBuffers.Offset
                ; -----------------------------------------

                ; 1737 тактов

                ; ToDo: добавить инициализацию 22 * 8 стобов гексагонаЫ

                endif ; ~_TILEMAP_UPDATE_BUFFERS_
