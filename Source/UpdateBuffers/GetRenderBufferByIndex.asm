
                ifndef _UPDATE_BUFFERS_GET_RENDER_BY_INDEX_
                define _UPDATE_BUFFERS_GET_RENDER_BY_INDEX_
; -----------------------------------------
; определение адреса Render-буфера по индексу гексагона
; In:
;   A - индекс в рендер буфере (0-39)
; Out:
;   B - -1/0 чётность, нечётность строки
;   C - ширина (оставшиеся/целая) гексагона
;   A - найденый индекс/смещение в рендер буфере обрабатываемого гексагона +80
; Corrupt:
;   IX, D, BC, AF, AF'
; Note:
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
                
                LD IX, Adr.DisplayList
                LD A, (GameState.DisplayListLen)
                LD B, A
.Loop           LD A, (IX + 1)
                CP C
                JR Z, .First
                JR C, .InRow    ; в строке (нужно искать)

                ; следующий элемент списка отображения
                LD A, IXL
                ADD A, Size.DisplayList.ElementSize
                LD IXL, A

                DJNZ .Loop
                NOP

.Unsuccess      SCF                                                             ; неудачное выполнение
                RET

.First          ; расчёт ширины гексагона в ренер буфере
                LD C, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                RES 7, C
                LD A, HEXTILE_SIZE_X
                SUB C
                LD C, A                                                         ; ширина гексагона в ренер буфере (0-5)
                LD A, (IX + 2)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона +80
                JR .Success

.InRow          ; расчёт дельты по горизонтали
                SUB C
                LD D, A

                ; расчёт ширины гексагона в ренер буфере
                LD C, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                RES 7, C
                LD A, HEXTILE_SIZE_X
                SUB C
                LD C, A                                                         ; ширина гексагона в ренер буфере (0-5)
                
                LD A, SCR_WORLD_SIZE_X
                EX AF, AF'
                LD A, (IX + 2)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона +80

                ; цикл поиска
.HexagonLoop    EX AF, AF'
                SUB C
                JR Z, .Unsuccess
                JR C, .Unsuccess                                                ; 
                EX AF, AF'
                ADD A, C
                
                LD C, HEXTILE_SIZE_X                                            ; ширина гексагона (следующего)
                INC D
                JR NZ, .HexagonLoop

                EX AF, AF'
                CP HEXTILE_SIZE_X
                JR NC, .L1

                LD C, A
.L1             EX AF, AF'

.Success        PUSH AF
                LD A, (IX + 0)
                ADD A, A    ; x2
                SBC A, A
                LD B, A     ; если нулевая строка то -1, иначе ноль
                POP AF
                
                OR A                                                            ; успешное выполнение
                RET

                display " - Get address render buffer by index:\t\t", /A, GetRenderBuffer, "\t= busy [ ", /D, $-GetRenderBuffer, " byte(s)  ]"

                endif ; ~_UPDATE_BUFFERS_GET_RENDER_BY_INDEX_
