
                ifndef _UPDATE_BUFFERS_UPDATE_HEXTILE_
                define _UPDATE_BUFFERS_UPDATE_HEXTILE_
; -----------------------------------------
; обновление Render-буфера указанного гексогонального тайла
; In:
;   DE - адрес обновляемого гексогонального тайла
; Out:
; Corrupt:
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
Hextile:        PUSH DE
                LD A, E
                EXX
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
                CALL UtilsBuffer.GetRender                                      ; обновление адреса Render-буфера по индексу гексагона
                POP HL
                EXX
                RET C
                
                EXX
                LD D, H
                LD E, L
                LD L, A
                PUSH BC

.CalcOffset     ; расчёт смещения верёд/назад
                LD A, B
                NEG
                ADD A, TILEMAP_WIDTH_DATA
                LD C, A     ; назад
                LD A, B
                ADD A, TILEMAP_WIDTH_DATA
                LD B, A     ; вперёд

.SetFlagUpdate  ; вперёд
                LD A, E
                ADD A, B
                LD B, E
                CP 40
                EX DE, HL
                JR NC, .Back1

                LD L, A
                SET 7, (HL)
                INC A
                CP 40
                JR NC, .Back1

                LD L, A
                SET 7, (HL)
.Back1          EX DE, HL

                ; назад
                LD A, B
                SUB C
                LD E, A
                EX DE, HL
                JP M, .Back2

                SET 7, (HL)
.Back2          INC L
                JP M, .Back3

                SET 7, (HL)
.Back3          EX DE, HL

                POP BC
                LD B, C
.Loop           LD (HL), #01    ; текущий тайл

                ; тайл ниже
                LD A, L
                ADD A, 22
                JR C, .L1
                LD E, A
                EX DE, HL
                SET 0, (HL)
                SET 1, (HL)                                                     ; ToDo: установка флага обновления половины гексагона
                                                                                ; если под текущим гексагоном тоже обновляется, то данный включенный флаг
                                                                                ; блокирует обновление нижнего.
                                                                                ; необходимо удостовериться что нижний тайл не убновляется перед тем как ставить,
                                                                                ; иначе нужно его сбрасывать!
                EX DE, HL
.L1
                ; тайл выше
                LD A, L
                SUB 22
                CP 80
                JR C, .L3
                LD E, A
                EX DE, HL
                SET 0, (HL)
                RES 1, (HL)
                EX DE, HL
.L3
                INC L
                DJNZ .Loop
                EXX

                OR A
                RET

                display " - Update hextile:\t\t\t\t\t", /A, Hextile, "\t= busy [ ", /D, $-Hextile, " byte(s)  ]"

                endif ; ~_UPDATE_BUFFERS_UPDATE_HEXTILE_
