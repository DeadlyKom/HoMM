                ifndef _WORLD_SCREEN_EFFECTS_LIGHTNING_BOLT_
                define _WORLD_SCREEN_EFFECTS_LIGHTNING_BOLT_

                module Bolt
; -----------------------------------------
; создание случайной ломаной разряда для очередной вспышки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   включена страница 7, прежний разряд уже стёрт перед переносом кадра
; -----------------------------------------
Create:         ; выбор начальной координаты разряда внутри боковых границ
.RandomX        CALL World.SharedScreen.Effects.Rain.Random
                DEC A
                CP BOLT_MAX_X - BOLT_MIN_X + 1
                JR NC, .RandomX                                                 ; переход, если случайная координата выходит за допустимую ширину

                ADD A, BOLT_MIN_X
                LD E, A
                LD D, SCR_WORLD_POS_Y << 3
                LD HL, Points
                LD B, BOLT_POINTS
.Point          ; сохранение очередной вершины разряда
                LD (HL), E
                INC HL
                LD (HL), D
                INC HL
                DEC B
                JR Z, .Done                                                     ; переход, если все вершины разряда сохранены

                ; расчёт случайного бокового излома относительно прежней вершины
                CALL World.SharedScreen.Effects.Rain.Random
                AND BOLT_JIT_MASK
                SUB BOLT_JIT_BIAS
                ADD A, E

                ; проверка левой границы вершин разряда
                CP BOLT_MIN_X
                JR NC, .CheckRight                                              ; переход, если вершина не вышла за левую границу

                LD A, BOLT_MIN_X
.CheckRight     ; проверка правой границы вершин разряда
                CP BOLT_MAX_X + 1
                JR C, .Next                                                     ; переход, если вершина не вышла за правую границу

                LD A, BOLT_MAX_X
.Next           LD E, A

                ; расчёт высоты следующей вершины разряда
                LD A, D
                ADD A, BOLT_STEP_Y
                LD D, A
                JR .Point

.Done           XOR A
                LD (Shown), A
                JP CreateBranches

; -----------------------------------------
; создание двух верхних ветвей и возможной одной средней ветви
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ветвь направлена в сторону от следующего основного отрезка
; -----------------------------------------
CreateBranches: ; выбор наличия средней ветви в дополнение к двум верхним
                CALL World.SharedScreen.Effects.Rain.Random
                AND 1
                ADD A, 2
                LD (BranchCount), A
                LD B, A
                LD C, 0
.Loop           PUSH BC
                LD B, 0

                ; проверка выбора корня верхней или средней ветви
.RandomRoot     LD A, C
                CP 2
                JR NC, .MiddleRoot                                              ; переход, если создаётся необязательная средняя ветвь

                ; выбор внутренней вершины верхней части разряда
                CALL World.SharedScreen.Effects.Rain.Random
                DEC A
                CP BOLT_TOP_SEGS - 1
                JR NC, .RandomRoot                                              ; переход, если номер вышел за диапазон внутренних вершин

                INC A
                JR .RootReady

.MiddleRoot     ; выбор вершины в средней части, исключая её конечную точку
                CALL World.SharedScreen.Effects.Rain.Random
                DEC A
                CP BOLT_MID_SEGS - BOLT_TOP_SEGS
                JR NC, .RandomRoot                                              ; переход, если номер вышел за диапазон средней части

                ADD A, BOLT_TOP_SEGS
.RootReady      LD D, A

                ; проверка необходимости исключить корень первой ветви
                LD A, C
                OR A
                LD A, D
                JR Z, .UseRoot                                                  ; переход, если создаётся первая ветвь

                ; проверка различия корней двух ветвей
                LD HL, BranchRoots
                CP (HL)
                JR Z, .RandomRoot                                               ; переход, если выбран корень уже созданной ветви

.UseRoot        ; сохранение номера корня и получение адреса основной вершины
                LD HL, BranchRoots
                ADD HL, BC
                LD (HL), D
                LD A, D
                ADD A, A
                LD E, A
                LD D, 0
                LD HL, Points
                ADD HL, DE

                ; расчёт направления следующего основного отрезка
                LD E, (HL)
                INC HL
                INC HL
                LD A, (HL)
                SUB E
                LD E, 1
                JP M, .Direction                                                ; переход, если основной отрезок уходит влево, ветвь направляем вправо

                JR Z, .RandomSide                                               ; переход, если основной отрезок вертикальный, сторону выбираем случайно

                LD E, -1
                JR .Direction

.RandomSide     CALL World.SharedScreen.Effects.Rain.Random
                AND 1
                JR Z, .Direction                                                ; переход, если выбрано ответвление вправо

                LD E, -1
.Direction      ; сохранение направления боковой ветви
                LD HL, BranchDirs
                ADD HL, BC
                LD (HL), E

                ; выбор и сохранение длины боковой ветви
                CALL World.SharedScreen.Effects.Rain.Random
                AND BOLT_ARM_MASK
                ADD A, BOLT_ARM_MIN
                LD HL, BranchLength
                ADD HL, BC
                LD (HL), A
                POP BC

                ; переход к описанию следующей боковой ветви
                INC C
                DEC B
                JP NZ, .Loop                                                    ; переход, если остались несозданные боковые ветви

                RET

; -----------------------------------------
; стирание прежнего разряда повторным XOR до переноса кадра
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Erase:          ; проверка наличия разряда на теневом экране
                LD A, (Shown)
                OR A
                RET Z                                                           ; выход, если разряд не нарисован

                ; стирание той же ломаной без изменения её вершин
                CALL Render
                XOR A
                LD (Shown), A
                RET

; -----------------------------------------
; рисование раскрываемой части разряда или полного канала во время вспышки
; In:
;   A - число отображаемых отрезков основного разряда
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   перед повторным рисованием требуется Erase, Shown сохраняет точную длину для стирания
; -----------------------------------------
Draw:           ; проверка защиты от повторного XOR без предварительного стирания
                LD C, A
                LD A, (Shown)
                OR A
                RET NZ                                                          ; выход, если разряд уже нарисован

                ; отображение ломаной и сохранение признака её присутствия
                LD A, C
                LD (Shown), A
                CALL Render
                RET

; -----------------------------------------
; XOR ломаной с однократным рисованием каждого стыка отрезков
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   IX сохраняется, последний пиксель отрезка рисуется следующим отрезком
; -----------------------------------------
Render:         ; обход соседних пар вершин разряда
                PUSH IX
                LD IX, Points
                LD A, (Shown)
                LD B, A
.Segment        PUSH BC
                LD E, (IX + FVector8.X)
                LD D, (IX + FVector8.Y)

                ; расчёт знакового смещения конца отрезка по горизонтали
                LD A, (IX + FVector8 + FVector8.X)
                SUB E
                CALL Segment

                ; переход к следующей паре вершин
                LD DE, FVector8
                ADD IX, DE
                POP BC
                DJNZ .Segment

                ; отображение конечной точки текущего шага раскрытия
                LD E, (IX + FVector8.X)
                LD D, (IX + FVector8.Y)
                CALL Pixel
                CALL RenderBranches
                POP IX
                RET

; -----------------------------------------
; XOR сохранённых боковых ветвей без повторного рисования корней
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
RenderBranches: ; обход созданных боковых ветвей
                LD A, (BranchCount)
                LD B, A
                LD C, 0
.Loop           PUSH BC
                LD B, 0

                ; получение координат внутренней вершины основного разряда
                LD HL, BranchRoots
                ADD HL, BC
                LD A, (HL)

                ; проверка принадлежности корня уже раскрытой части разряда
                LD HL, Shown
                CP (HL)
                JR NC, .Skip                                                    ; переход, если основной канал ещё не дошёл до корня ветви

                ; получение координат корня видимой ветви
                ADD A, A
                LD E, A
                LD D, 0
                LD HL, Points
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)

                ; чтение направления и длины сохранённой ветви
                LD HL, BranchDirs
                ADD HL, BC
                LD A, (HL)
                PUSH AF
                LD HL, BranchLength
                ADD HL, BC
                LD B, (HL)
                POP AF
                LD C, A
                CALL BranchLine
.Skip           POP BC

                ; переход к следующей сохранённой ветви
                INC C
                DEC B
                JP NZ, .Loop                                                    ; переход, если осталась неотображённая боковая ветвь

                RET

; -----------------------------------------
; XOR диагональной ветви с исключением пикселя основного разряда в корне
; In:
;   DE - корень ветви, D - y, E - x в пикселях
;   BC - B длина ветви, C знаковый шаг по горизонтали, -1 или 1
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
BranchLine:     ; расчёт первого пикселя рядом с корнем без его повторного XOR
                LD A, E
                ADD A, C
                LD E, A
.Pixel          PUSH BC
                PUSH DE
                CALL Pixel
                POP DE
                POP BC

                ; расчёт следующего пикселя диагональной ветви
                INC D
                LD A, E
                ADD A, C
                LD E, A
                DJNZ .Pixel
                RET

; -----------------------------------------
; XOR отрезка с ведущей вертикальной осью и накоплением ошибки
; In:
;   DE - начало отрезка, D - y, E - x в пикселях
;   A - знаковое горизонтальное смещение конца отрезка
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   высота равна BOLT_STEP_Y, модуль горизонтального смещения не превышает высоту
;   конечная точка не рисуется во избежание двойного XOR на стыках
; -----------------------------------------
Segment:        ; определение направления смещения отрезка
                LD C, 1
                OR A
                JP P, .Magnitude                                                ; переход, если конец отрезка находится справа или прямо под началом

                LD C, -1
                NEG
.Magnitude      LD H, A
                LD L, BOLT_STEP_Y / 2
                LD B, BOLT_STEP_Y
.Row            PUSH HL
                PUSH DE
                PUSH BC
                CALL Pixel
                POP BC
                POP DE
                POP HL

                ; расчёт накопленной горизонтальной ошибки следующей строки
                INC D
                LD A, L
                ADD A, H
                CP BOLT_STEP_Y
                JR C, .Error                                                    ; переход, если горизонтальное смещение пока не требуется

                SUB BOLT_STEP_Y
                LD L, A
                LD A, E
                ADD A, C
                LD E, A
                JR .Next

.Error          LD L, A
.Next           DJNZ .Row
                RET

; -----------------------------------------
; XOR пикселя разряда по существующим таблицам адресов и масок
; In:
;   DE - положение внутри игрового окна, D - y, E - x в пикселях
; Out:
; Corrupt:
;   HL, DE, AF
; Note:
;   границы обеспечиваются генерацией вершин и монотонным обходом отрезка
; -----------------------------------------
Pixel:          ; получение экранного адреса и маски пикселя из готовых таблиц
                LD H, HIGH Adr.ScrAdrTable
                LD L, D
                LD A, (HL)
                INC H
                LD D, (HL)
                INC H
                LD L, E
                OR (HL)
                LD E, A
                INC H

                ; отображение или стирание пикселя теневого экрана через XOR
                LD A, (DE)
                XOR (HL)
                LD (DE), A
                RET

                ; состояние и вершины разряда находятся в существующей области кода страницы 7
Shown           DB 0                                                            ; число нарисованных отрезков, 0 разряд отсутствует
BranchCount     DB 0                                                            ; число ветвей, две верхние и возможная одна средняя
BranchRoots     DB 0, 0, 0                                                      ; номера внутренних вершин, из которых выходят боковые ветви
BranchDirs      DB 0, 0, 0                                                      ; знаковые горизонтальные шаги боковых ветвей
BranchLength    DB 0, 0, 0                                                      ; длины боковых ветвей в пикселях
Points          FVector8 {0, 0}                                                 ; начальная вершина, экранные координаты X, Y
                dup BOLT_POINTS - 1
                FVector8 {0, 0}
                edup

                endmodule
                endif ; ~_WORLD_SCREEN_EFFECTS_LIGHTNING_BOLT_
