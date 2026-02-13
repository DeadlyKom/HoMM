
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
                ;
                PUSH DE
                PUSH BC
                CALL .UpdateRow
                POP BC
                POP DE
                RET C   ; выход, если не получается обнаружить bound спрайта

                ; нижняя грань bound спрайта
                EX AF, AF'
                LD A, D         ; позиция спрайта в пикселях по оси Y
                ADD A, B
                LD D, A
                EX AF, AF'
                JR Z, .UpdateRow

                PUSH DE
                PUSH BC
                CALL .UpdateRow
                POP BC
                POP DE

                LD A, D         ; позиция спрайта в пикселях по оси Y
                ADD A, B
                LD D, A

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
                LD E, A
                AND %00000111
                JR Z, $+3
                INC C
                SRL E
                SRL E
                SRL E

                LD IX, (GameState.DisplayList)
                LD A, (GameState.DisplayListLen)
                LD B, A
.Loop           ; следующий элемент списка отображения
                LD A, IXL
                ADD A, -Size.DisplayList.ElementSize
                LD IXL, A
                
                LD A, (IX + 3)                                                  ; номер строки по вертикали в пикселях
                CP D            ; D - позиция спрайта в пикселях по оси Y
                JR NC, .FoundRow; найдена нужная строка
                DJNZ .Loop
                SCF                                                             ; строка не была найдена
                RET
.FoundRow       ; найдена нужная строка
                SUB D           ; отступ от нижней границы гексагона
                PUSH AF         ; оставшаяся высота

                ; расчёт ширины гексагона в ренер буфере
                LD B, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                RES 7, B
                LD A, HEXTILE_SIZE_X
                SUB B
                LD B, A                                                         ; ширина гексагона в ренер буфере (0-5)

                ; чтение индексов
                LD L, (IX + 1)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона
                LD A, SCR_WORLD_SIZE_X
                SUB E
                LD H, A
                LD A, E
                LD E, H     ; количество доступных колонок
                EX AF, AF'
                LD A, (IX + 2)                                                  ; индекс/смещение в рендер буфере обрабатываемого гексагона +80

                ; цикл поиска
.HexagonLoop    EX AF, AF'
                SUB B                                                           ; ширина гексагона в ренер буфере (0-5)
                JR Z, .Found
                JR C, .Found

                ; смещение колонок в строке
                EX AF, AF'
                ADD A, B
                
                LD B, HEXTILE_SIZE_X                                            ; ширина гексагона (следующего)
                INC L
                JR .HexagonLoop

.Found          EX AF, AF'
                LD H, A
                EX AF, AF'

                ; добавить смещение к столбцам рендер буфера
                ADD A, B
                ; LD B, A             ; смещение внутри гексагона
                ADD A, H            ; сместить строку в гексагоне
                LD H, A

                LD A, E
                EX AF, AF'

                ; адрес в рендер буфере гексагонов
                LD E, L

                ; количество доступных гексагонов в строке
                LD D, (IX + 0)                                                  ; первая рисуемая колонка первого гексагона (0-5)
                BIT 0, D
                JR Z, .L1
                LD A, #82
                SUB D
                JR C, .L1
                INC L
.L1             LD A, TILEMAP_WIDTH_DATA;-1
                SUB L
                ADD A, (IX + 1)                                                    ; индекс/смещение в рендер буфере обрабатываемого гексагона
                LD L, A

                LD D, HIGH Adr.RenderBuffer
                EX DE, HL

                JR Z, .L2
                SET 7, (HL)     ; текущий гексагон
                ; LD A, HEXTILE_SIZE_X
                ; SUB B           ; смещение внутри гексагона
                ; SUB C           ; ширины спрайта в колонках
                ; JR NC, .L2      ; не нужно следующий гексагон обновлять

                ; проверка доступности следующего гексагона
                DEC E
                JR Z, .L2
                INC L
                SET 7, (HL)     ; следующий гексагон
.L2
                LD B, C
                LD L, D
                EX AF, AF'
.RenderLoop     EX AF, AF'
                SET 0, (HL)
                INC L
                EX AF, AF'
                DEC A
                JR Z, .Finish
                DJNZ .RenderLoop

.Finish         POP AF
                RET

                display " - Update sprite bound:\t\t\t\t", /A, SpriteBound, "\t= busy [ ", /D, $-SpriteBound, " byte(s)  ]"

                endif ; ~_BUFFERS_UPDATE_SPRITE_BOUND_
