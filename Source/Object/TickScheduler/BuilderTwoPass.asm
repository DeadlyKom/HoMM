                ifndef _OBJECT_TICK_SCHEDULER_BUILDER_TWO_PASS_
                define _OBJECT_TICK_SCHEDULER_BUILDER_TWO_PASS_
; -----------------------------------------
; построитель порядка/расписания планировщика обновлений тиков (двухпроходный)
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; Note:
;   ⚠️ ВАЖНО ⚠️
;   необходимо включить страницу работы с объектами (страница 0)
;
;   первый проход:
;       - определяет приоритет каждого чанка
;       - сохраняет его во временный массив
;       - считает размеры первых двух диапазонов
;
;   второй проход:
;       без вставок и сдвигов раскладывает чанки в ChunkOrder
;       простым добавлением в конец нужного диапазона
;
;   границы приоритетов задаются радиусом:
;       - если  radius  = 0..1, то приоритет 0
;       - инача radius  = 2,    то приоритет 1
;       - иначе radius >= 3,    то приоритет 2
; ----------------------------------------
BuilderTwoPass: ; -----------------------------------------
                ; преобразование тайловых координат (центра экрана) в координаты чанка
                ; определение центрального чанка видимой области
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                ADD A, TILEMAP_WIDTH_DATA >> 1
                                ; %0XXXXXXX : 0
                RRA             ; %00XXXXXX : X
                RRA             ; %X00XXXXX : X
                RRA             ; %XX00XXXX : X
                AND %00001111   ; %0000XXXX : X
                LD (.CenterChunk_X), A

                ; дополнительное смещение центра экрана
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                ADD A, TILEMAP_HEIGHT_DATA >> 1
                                ; %0YYYYYYY : 0
                RRA             ; %00YYYYYY : Y
                RRA             ; %Y00YYYYY : Y
                RRA             ; %YY00YYYY : Y
                AND %00001111   ; %0000YYYY : Y
                LD (.CenterChunk_Y), A
                ; -----------------------------------------

                ; -----------------------------------------
                ; инициализация
                ; -----------------------------------------
                LD L, MAX_WORLD_CHUNK_SIZE - 1                                  ; счётчик буфера
                LD DE, #0000                                                    ; обнуление счётчиков первых двух диапазонов

                ; -----------------------------------------
                ; первый проход
                ; -----------------------------------------

                ; определение приоритета каждого чанка
                LD B, MAX_WORLD_CHUNK_Y - 1                                     ; Y-координата чанка
.RowLoop        LD C, MAX_WORLD_CHUNK_X - 1                                     ; X-координата чанка

.ColumnLoop     ; -----------------------------------------
                ; расчёт максимальной дельты расстояния между двумя точками

                ; |Y - CenterY|
                LD A, B
.CenterChunk_Y  EQU $+1
                SUB #00
                JR NC, $+4
                NEG
                LD H, A ; A = |Y - CenterY|

                ; |X - CenterX|
                LD A, C
.CenterChunk_X  EQU $+1
                SUB #00
                JR NC, $+4
                NEG

                ; max (|X - CenterX|, |Y - CenterY|)
                ;   где A = |X - CenterX|, H = |Y - CenterY|
                CP H
                JR NC, $+3
                LD A, H
                
                ; -----------------------------------------
                ; приоритет 0
                LD H, #00
                INC E
                CP #02
                JR C, .SelectPriority

                ; -----------------------------------------
                ; приоритет 1
                DEC E
                INC D
                INC H   ; H = 1
                CP #03
                JR C, .SelectPriority

                ; -----------------------------------------
                ; приоритет 2
                DEC D
                INC H   ; H = 2

.SelectPriority LD A, H
                LD H, HIGH Adr.TickSchedulerPriority
                LD (HL), A
                DEC L

                ; цикл по горизонтали
                DEC C
                JP P, .ColumnLoop
                ; цикл по вертикали
                DEC B
                JP P, .RowLoop

                ; -----------------------------------------
                ; подготовка диапазонов:
                LD HL, TickScheduler.Variables + FTickScheduler.Range_0
                XOR A

                ;   Range_0 = [0 .. E)
                LD (HL), A                                                      ; Range_0.FirstIndex
                INC HL
                INC HL
                LD (HL), A                                                      ; Range_0.Pointer
                INC HL

                ;   Range_1 = [E .. E + D)
                LD (HL), E                                                      ; Range_1.FirstIndex
                INC HL
                INC HL
                LD (HL), E                                                      ; Range_1.Pointer
                INC HL

                ;   Range_2 = [E + D .. 36)
                LD A, E
                LD C, E     ; сохранение первый указатель
                ADD A, D
                LD B, A     ; сохранение второй указатель
                LD (HL), A                                                      ; Range_2.FirstIndex
                INC HL
                INC HL
                LD (HL), A                                                      ; Range_2.Pointer

                ; -----------------------------------------
                ; подготовка указателей записи:

                ; P0 -> начало массива ChunkOrder
                XOR A
                LD DE, TickScheduler.Variables + FTickScheduler.ChunkOrder

                ; P1 -> начало второго диапазона
                LD IXL, C
                LD IXH, A
                ADD IX, DE

                ; P2 -> начало третьего диапазона
                LD IYL, B
                LD IYH, A
                ADD IY, DE
                EX DE, HL

                ; -----------------------------------------
                ; второй проход
                ; -----------------------------------------

                ; чтение уже вычисленного приоритета и раскладка чанка
                ; в конец соответствующего диапазона
                LD DE, Adr.TickSchedulerPriority
                LD BC, MAX_WORLD_CHUNK_SIZE << 8                                ; C - текущий индекс чанка

.PassTwoLoop    ; чтение приоритета первого прохода
                LD A, (DE)
                INC E

                ; проверка приоритета
                OR A
                JR Z, .Priority_0                                               ; переход, если нулевой приоритет
                DEC A
                JR Z, .Priority_1                                               ; переход, если первый приоритет

                ; второй приоритет
                LD (IY + 0), C
                INC IY
                JR .PassTwoNext

.Priority_1     ; первый приоритет
                LD (IX + 0), C
                INC IX
                JR .PassTwoNext

.Priority_0     ; нулевой приоритет
                LD (HL), C
                INC HL

.PassTwoNext    ; следующий чанк
                INC C
                DJNZ .PassTwoLoop

                ; порядок чанков актуален
                LD HL, TickScheduler.Variables + FTickScheduler.Flags
                RES CHUNK_ORDER_NEED_REBUID_BIT, (HL)
                RET

                endif ; ~_OBJECT_TICK_SCHEDULER_BUILDER_TWO_PASS_
