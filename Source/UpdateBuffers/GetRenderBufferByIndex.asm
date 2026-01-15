
                ifndef _UPDATE_BUFFERS_GET_RENDER_BY_INDEX_
                define _UPDATE_BUFFERS_GET_RENDER_BY_INDEX_
; -----------------------------------------
; обновление адреса Render-буфера по индексу гексагона
; In:
; Out:
; Corrupt:
; Note:
;
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetRenderBuffer LD C, A

                ; -----------------------------------------
                ; представление дисплейного списка
                ; +0 - первая рисуемая колонка первого гексагона (0-5)
                ; +1 - индекс/смещение в рендер буфере обрабатываемого гексагона
                ; +2 - индекс/смещение в рендер буфере обрабатываемого гексагона +80
                ; +3 - номер строки по вертикали в пикселях
                ; +4 - количество пропускаемых знакомест (спрайт находится ниже экрана)
                ; -----------------------------------------
                
                LD IX, Kernel.Hex.DisplayList
                LD A, (GameState.DisplayListLen)
                LD B, A
.Loop           LD A, (IX + 1)
                CP C
                JR Z, .First
                JR C, .InRow    ; в строке (нужно искать)

                ; следующий элемент списка отображения
                LD A, IXL
                ADD A, Kernel.Hex.DisplayList.ElementSize
                LD IXL, A

                DJNZ .Loop

                ; ToDo: временно!
                ; следующий элемент списка отображения
                LD A, IXL
                ADD A, -Kernel.Hex.DisplayList.ElementSize
                LD IXL, A
                JR .First

                ; SCF                                                             ; неудачное выполнение
                ; RET

.First          ; расчёт ширины гексагона в ренер буфере
                LD B, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                LD A, B
                AND %00000111
                LD C, A
                LD A, HEXTILE_SIZE_X
                SUB C
                LD C, A                                                         ; ширина гексагона в ренер буфере (0-5)
                LD A, (IX + 2)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона +80
                
.Success        SRL B
                SRL B
                SRL B
                
                OR A                                                            ; успешное выполнение
                RET

.InRow          ; расчёт дельты по горизонтали
                SUB C
                LD D, A

                ; расчёт ширины гексагона в ренер буфере
                LD B, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                LD A, B
                AND %00000111
                LD C, A
                LD A, HEXTILE_SIZE_X
                SUB C
                LD C, A                                                         ; ширина гексагона в ренер буфере (0-5)
                LD A, (IX + 2)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона +80

                ; цикл поиска
.HexagonLoop    ADD A, C
                LD C, HEXTILE_SIZE_X                                            ; ширина гексагона (следующего)
                INC D
                JR Z, .Success
                JR .HexagonLoop

                endif ; ~_UPDATE_BUFFERS_GET_RENDER_BY_INDEX_
