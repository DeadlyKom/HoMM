
                ifndef _BUFFERS_UPDATE_SPRITE_BOUND_
                define _BUFFERS_UPDATE_SPRITE_BOUND_
; -----------------------------------------
; обновление Render-буфера указанного bound спрайта
; In:
;   DE - позиция спрайта в пикселях (D - y, E - x)
;   BC - размер bound спрайта в пикселях (B - y, C - x)
; Out:
; Corrupt:
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
SpriteBound:    ; -----------------------------------------
                ; представление дисплейного списка
                ; +0 - первая рисуемая колонка первого гексагона (0-5)
                ; +1 - индекс/смещение в рендер буфере обрабатываемого гексагона
                ; +2 - индекс/смещение в рендер буфере обрабатываемого гексагона +80
                ; +3 - номер строки по вертикали в пикселях
                ; +4 - количество пропускаемых знакомест (спрайт находится ниже экрана)
                ; -----------------------------------------

                ; ToDo: грубое увеличение bound спрайта
                ; увеличим размеры очищаемой области вокруг спрайта в 2 раза
                ; позволяет не хранить предыдущее состояние спрайта, дабы очистить точно его место
                ; а так же заставить перерисовать перед новым состоянием спрайта
                
                ; модификация ширины обновления
                LD A, C
                LD L, A
                ADD A, C
                LD C, A

                ; центрируем новую ширину обновления
                LD A, E
                SRA L
                SUB L
                LD E, A

                PUSH DE
                
                ; нижняя грань bound спрайта
                LD A, D         ; позиция спрайта в пикселях по оси Y
                ADD A, B
                LD D, A

                ;
                PUSH BC
                CALL .UpdateRow
                POP BC
                POP DE
                RET NC  ; выход, если не получается обнаружить bound спрайта
                SUB B
                RET NC  ; спрайт поместился в гексагоне

.UpdateRow      ; округление до знакоместах
                LD A, C                                                         ; ширины спрайта в пикселях
                LD C, #00
                SRL A
                ADC A, C
                RRA
                ADC A, C
                RRA
                ADC A, C
                LD C, A

                ; округление до знакоместах
                ; корректировка позиции относительно левого края игрового мира
                LD A, E
                SUB SCR_WORLD_POS_X << 3
                LD E, #00
                SRL A
                ADC A, E
                RRA
                ADC A, E
                RRA
                ADC A, E
                LD E, A

                ; ; сохранение высоты спрайта
                ; LD A, B
                ; EX AF, AF'

                ; обратный поиск от верхней строки к нижней
                LD IX, (GameState.DisplayList)
                LD A, (GameState.DisplayListLen)
                INC A           ; +1
                LD B, A
                
.Djnz           DJNZ .Loop
                ; строка не была найдена
                OR A
                RET

.Loop           ; переход к следующему элементу списка отображения
                EX DE, HL
                LD DE, -Size.DisplayList.ElementSize
                ADD IX, DE
                EX DE, HL

                ; определение строки экранного блока
                LD A, (IX + 3)                                                  ; номер строки по вертикали в пикселях
                CP D            ; D - позиция спрайта в пикселях по оси Y
                JR C, .Djnz
                ; найдена нужная строка

                SUB D           ; отступ от нижней границы гексагона
                NEG
                ADD A, HEXTILE_BASE_SIZE_Y << 3
                PUSH AF         ; оставшаяся высота

                ; расчёт ширины гексагона в ренер буфере
                LD B, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                RES 7, B
                LD A, HEXTILE_SIZE_X
                SUB B
                LD B, A                                                         ; ширина гексагона в ренер буфере (0-5)

                ; чтение индексов
                LD L, (IX + 1)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона
                LD H, (IX + 2)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона +80

                ;
                LD A, E
                LD E, HEXTILE_SIZE_X

.HexagonLoop    SUB B
                JR C, .Found
                INC L
                EX AF, AF'
                LD A, H
                ADD A, B
                LD H, A
                EX AF, AF'
                LD B, E
                JR .HexagonLoop

.Found          ; добавить смещение к столбцам рендер буфера
                ADD A, B
                LD B, A
                JR NZ, $+3
                LD B, E
                ADD A, H
                LD H, A

                LD A, E
                LD D, HIGH Adr.RenderBuffer
                LD E, L
                EX DE, HL
                
                SUB B
                SET 7, (HL)     ; текущий гексагон
                SUB C
                JR NC, $+5
                INC L
                ; есть вероятность что такое огрубление может переполниться
                SET 7, (HL)     ; следующий гексагон

                LD B, C
                LD L, D
.RenderLoop     SET 0, (HL)
                INC L
                JR Z, $         ; переполнение ОШИБКА!
                DJNZ .RenderLoop

                POP AF
                RET

                display " - Update sprite bound:\t\t\t\t", /A, SpriteBound, "\t= busy [ ", /D, $-SpriteBound, " byte(s)  ]"

                endif ; ~_BUFFERS_UPDATE_SPRITE_BOUND_
