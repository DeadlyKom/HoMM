
                ifndef _BUFFERS_GET_RENDER_INDEX_BY_COORDINATES_
                define _BUFFERS_GET_RENDER_INDEX_BY_COORDINATES_
; -----------------------------------------
; определение индекса Render-буфера по координатам гексагона (обёртка)
; In:
;   BC' - координаты гексагона под курсором (B - y, C - x)
; Out:
;   A'  - индекс в рендер буфере (0-39)
;   флаг переполнения Carry сброшен, если получилось определить индекс
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetIndexRender.Wrap:
                EXX
                CALL GetIndexRender
                EX AF, AF'
                RET
; -----------------------------------------
; определение индекса Render-буфера по координатам гексагона
; In:
;   BC - координаты гексагона под курсором (B - y, C - x)
; Out:
;   A - индекс в рендер буфере (0-39)
;   флаг переполнения Carry сброшен, если получилось определить индекс
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetIndexRender: ; вертикаль
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                NEG
                ADD A, B
                LD H, A

                ; -----------------------------------------
                ; представление дисплейного списка
                ; +0 - первая рисуемая колонка первого гексагона (0-5)
                ; +1 - индекс/смещение в рендер буфере обрабатываемого гексагона
                ; +2 - индекс/смещение в рендер буфере обрабатываемого гексагона +80
                ; +3 - номер строки по вертикали в пикселях
                ; +4 - количество пропускаемых знакомест (спрайт находится ниже экрана)
                ; -----------------------------------------

                LD A, (GameState.DisplayListLen)
                CP H
                RET C                                                           ; выход, нет такого значения в рендер буфере
                SCF                                                             ; установка флага, не получилось определить индекс
                RET Z                                                           ; выход, нижняя граница находится за пределами рендер буфера

                SUB H
                DEC A
                LD H, A
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, H    ; x5
                ADD A, LOW Adr.DisplayList + 1
                LD L, A
                LD H, HIGH Adr.DisplayList
                LD L, (HL)                                                      ; начальный индекс строки с учётом горизонтального смещения

                ; расчёт индекса конца текущей строки Render-буфера
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                NEG
                ADD A, B
                LD H, A
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, H    ; x5
                ADD A, TILEMAP_WIDTH_DATA
                LD H, A

                ; горизонталь
                BIT 0, B
                JR NZ, .Half
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                CP HEXTILE_SIZE_X >> 1
                JR C, $+3
                DEC C

.Half           LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                NEG
                ADD A, C
                SCF
                RET M       ; ошибка, нет такого значения в рендер буфере
                ADD A, L
                CP H
                CCF                                                             ; смена флага, если до смены был сброшен, то не получилось определить индекс
                                                                                ; индекс вышел за пределы текущей строки Render-буфера
                RET

                display " - Get index render buffer by coordinates:\t\t", /A, GetIndexRender, "\t= busy [ ", /D, $-GetIndexRender, " byte(s)  ]"

                endif ; ~_BUFFERS_GET_RENDER_INDEX_BY_COORDINATES_
