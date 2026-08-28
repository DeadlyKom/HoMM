
                ifndef _OBJECT_LIGHTMAP_
                define _OBJECT_LIGHTMAP_
; -----------------------------------------
; добавление света объекта во временную карту освещения
; In:
;   A  - профиль радиуса 1-7 из FObjectDefaultSettings.Variable_B
;   IY - адрес структуры объекта FObject
; Out:
;   IY сохраняется
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   необходимо включить страницу 0
;   карта освещения содержит 22 строки по 6 байт в Adr.SharedBuffer
; -----------------------------------------
LightmapSource: PUSH IY                                                         ; сохранение адреса объекта

                ; проверка отключённого радиуса источника света
                OR A
                JP Z, .LightmapSourceDone                                      ; выйти, если профиль радиуса равен нулю

                ; проверка верхней границы таблицы профилей света
                CP #08
                JR C, .LightmapProfileReady                                    ; сохранить профиль, если он находится в диапазоне 1-7
                LD A, #07                                                       ; ограничить неизвестный профиль максимальным радиусом

.LightmapProfileReady
                PUSH AF                                                         ; сохранение профиля радиуса

                ; расчёт точного положения основания объекта относительно экрана в формате 12.4
                CALL Utilities.TransformToScr

                ; расчёт горизонтального знакоместа основания объекта делением координаты 12.4 на 8 пикселей
                LD A, E
                ADD A, A                                                        ; перенос старшего дробного бита в Carry
                LD A, D
                RLA

                ; перевод экранного знакоместа в локальную координату карты освещения
                SUB SCR_WORLD_POS_X
                LD (.LightmapCenterX), A

                ; расчёт вертикального знакоместа основания объекта делением координаты 12.4 на 8 пикселей
                LD A, L
                ADD A, A                                                        ; перенос старшего дробного бита в Carry
                LD A, H
                RLA

                ; перевод экранного знакоместа в локальную координату карты освещения
                SUB SCR_WORLD_POS_Y
                LD (.LightmapCenterY), A

                POP AF                                                          ; восстановление профиля радиуса

                ; расчёт адреса профиля света по индексу 1-7
                DEC A
                ADD A, A    ; x2
                ADD A, LOW .LightmapProfileTable
                LD L, A
                ADC A, HIGH .LightmapProfileTable
                SUB L
                LD H, A

                ; чтение адреса строк выбранного профиля света
                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL

                ; расчёт первой экранной строки профиля относительно центра источника
                LD D, (HL)
                INC HL
                LD A, (.LightmapCenterY)
                SUB D
                LD (.LightmapRowY), A

.LightmapProfileLoop
                ; проверка достижения конца профиля света
                LD A, (HL)
                CP #FF
                JP Z, .LightmapSourceDone                                      ; выйти, если обработаны все строки профиля

                ; проверка выхода текущей строки выше экрана
                LD A, (.LightmapRowY)
                BIT 7, A
                JP NZ, .LightmapProfileSkipRow                                 ; пропустить строку с отрицательной координатой

                ; проверка выхода текущей строки ниже экрана
                CP SCR_WORLD_SIZE_Y
                JP NC, .LightmapProfileSkipRow                                 ; пропустить строку за нижней границей карты освещения

                ; нанесение внешней хорды уровнем освещения 2
                PUSH HL                                                         ; сохранение адреса строки профиля
                LD A, (HL)
                LD DE, .LightmapMergeLevel2
                LD (.LightmapMergeCall + 1), DE
                CALL .LightmapDrawHalfWidth
                POP HL                                                          ; восстановление адреса строки профиля

                INC HL                                                          ; переход к ширине средней хорды

                ; проверка наличия средней хорды в текущей строке
                LD A, (HL)
                CP #FF
                JR Z, .LightmapProfileSkipMiddle                               ; пропустить отсутствующую среднюю хорду

                ; нанесение средней хорды уровнем освещения 1
                PUSH HL                                                         ; сохранение адреса строки профиля
                LD DE, .LightmapMergeLevel1
                LD (.LightmapMergeCall + 1), DE
                CALL .LightmapDrawHalfWidth
                POP HL                                                          ; восстановление адреса строки профиля

.LightmapProfileSkipMiddle
                INC HL                                                          ; переход к ширине внутренней хорды

                ; проверка наличия внутренней хорды в текущей строке
                LD A, (HL)
                CP #FF
                JR Z, .LightmapProfileSkipInner                                ; пропустить отсутствующую внутреннюю хорду

                ; нанесение внутренней хорды уровнем освещения 0
                PUSH HL                                                         ; сохранение адреса строки профиля
                LD DE, .LightmapMergeLevel0
                LD (.LightmapMergeCall + 1), DE
                CALL .LightmapDrawHalfWidth
                POP HL                                                          ; восстановление адреса строки профиля

.LightmapProfileSkipInner
                INC HL                                                          ; переход к следующей строке профиля
                JR .LightmapProfileNextRow

.LightmapProfileSkipRow
                ; переход через три ширины невидимой строки профиля
                INC HL
                INC HL
                INC HL

.LightmapProfileNextRow
                ; расчёт экранной координаты следующей строки профиля
                LD A, (.LightmapRowY)
                INC A
                LD (.LightmapRowY), A
                JP .LightmapProfileLoop

.LightmapSourceDone
                POP IY                                                          ; восстановление адреса объекта
                RET
; -----------------------------------------
; нанесение горизонтальной хорды текущей строки профиля
; In:
;   A - половина ширины хорды
; Out:
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   LightmapCenterX и LightmapRowY содержат экранный центр и строку
; -----------------------------------------
.LightmapDrawHalfWidth
                LD C, A                                                         ; сохранение половины ширины хорды

                ; расчёт правой границы хорды относительно центра источника
                LD A, (.LightmapCenterX)
                LD D, A                                                         ; сохранение центра для расчёта левой границы
                ADD A, C

                ; проверка выхода всей хорды за левую границу экрана
                BIT 7, A
                JR NZ, .LightmapSpanOutside                                    ; выйти, если правая граница остаётся отрицательной

                ; проверка выхода правой границы хорды за экран
                CP SCR_WORLD_SIZE_X
                JR C, .LightmapRightReady                                      ; сохранить правую границу, если она находится внутри экрана
                LD A, SCR_WORLD_SIZE_X - 1                                     ; ограничить хорду правой границей карты освещения

.LightmapRightReady
                LD E, A                                                         ; правая граница хорды

                ; расчёт левой границы хорды относительно центра источника
                LD A, D
                SUB C

                ; проверка выхода левой границы за левый край экрана
                BIT 7, A
                JR Z, .LightmapLeftPositive                                    ; проверить правый край, если левая граница неотрицательная
                XOR A                                                           ; ограничить хорду левой границей карты освещения
                JR .LightmapLeftReady

.LightmapLeftPositive
                ; проверка выхода всей хорды за правую границу экрана
                CP SCR_WORLD_SIZE_X
                JR NC, .LightmapSpanOutside                                    ; выйти, если левая граница находится за экраном

.LightmapLeftReady
                LD D, A                                                         ; левая граница хорды
                LD A, (.LightmapRowY)                                           ; экранная строка хорды
                JP .LightmapDrawSpan

.LightmapSpanOutside
                RET
; -----------------------------------------
; нанесение упакованного отрезка карты освещения
; In:
;   A - экранная строка 0-21
;   D - левая граница 0-21
;   E - правая граница 0-21
; Out:
; Corrupt:
;   AF, BC, DE, HL
; -----------------------------------------
.LightmapDrawSpan
                ; расчёт смещения строки карты освещения: Y * 6
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                LD B, H
                LD C, L
                ADD HL, HL  ; x4
                ADD HL, BC  ; x6

                ; расчёт адреса первого байта строки во временной карте освещения
                LD BC, Adr.SharedBuffer
                ADD HL, BC

                ; расчёт номера байта левой границы и его адреса
                LD A, D
                SRL A
                SRL A
                LD (.LightmapSpanLeftByte), A
                ADD A, L                                                       ; перенос не возникает: 22 * 6 байт находятся внутри страницы
                LD L, A

                ; расчёт маски первого байта по знакоместу левой границы
                LD A, D
                AND #03
                LD B, A
                LD C, #FF
                JR Z, .LightmapStartMaskReady                                  ; сохранить полную маску, если хорда начинается с первого знакоместа байта

.LightmapStartMaskLoop
                SLA C
                SLA C
                DJNZ .LightmapStartMaskLoop                                    ; продолжить, пока маска не сдвинута к знакоместу левой границы

.LightmapStartMaskReady
                ; расчёт номера байта правой границы
                LD A, E
                LD D, A                                                         ; сохранение знакоместа правой границы
                SRL A
                SRL A
                LD (.LightmapSpanRightByte), A

                ; расчёт маски последнего байта по знакоместу правой границы
                LD A, D
                AND #03
                LD B, A
                LD E, #03
                JR Z, .LightmapEndMaskReady                                    ; сохранить одну пару битов, если хорда заканчивается первым знакоместом байта

.LightmapEndMaskLoop
                LD A, E
                RLCA
                RLCA
                OR E
                LD E, A
                DJNZ .LightmapEndMaskLoop                                      ; продолжить, пока маска не расширена до знакоместа правой границы

.LightmapEndMaskReady
                LD A, E
                LD (.LightmapSpanEndMask), A

                ; расчёт количества байтов между границами хорды включительно
                LD A, (.LightmapSpanLeftByte)
                LD D, A
                LD A, (.LightmapSpanRightByte)
                SUB D
                INC A
                LD B, A

                ; проверка размещения обеих границ хорды в одном байте
                CP #01
                JR NZ, .LightmapSpanMultiple                                   ; перейти к нескольким байтам, если границы находятся в разных байтах

                ; объединение начальной и конечной масок единственного байта
                LD A, (.LightmapSpanEndMask)
                AND C
                LD C, A
                JP .LightmapMergeCall

.LightmapSpanMultiple
                ; обновление первого частично или полностью занятого байта
                CALL .LightmapMergeCall
                INC L
                DEC B                                                           ; первый байт обработан

.LightmapSpanMiddleCheck
                ; проверка перехода к последнему байту хорды
                LD A, B
                CP #01
                JR Z, .LightmapSpanLast                                        ; перейти к конечной маске, если остался последний байт

                ; обновление очередного полного байта хорды
                LD C, #FF
                CALL .LightmapMergeCall
                INC L
                DEC B
                JR .LightmapSpanMiddleCheck

.LightmapSpanLast
                ; обновление последнего частично или полностью занятого байта
                LD A, (.LightmapSpanEndMask)
                LD C, A
                JP .LightmapMergeCall

.LightmapMergeCall
                CALL .LightmapMergeLevel0                                      ; адрес заменяется перед нанесением каждого уровня света
                RET
; -----------------------------------------
; объединение выбранных пар с уровнем света 0
; In:
;   HL - адрес байта карты освещения
;   C  - маска выбранных двухбитных полей
; Out:
; Corrupt:
;   AF
; -----------------------------------------
.LightmapMergeLevel0
                LD A, C
                CPL
                AND (HL)
                LD (HL), A
                RET
; -----------------------------------------
; объединение выбранных пар с уровнем света 1
; In:
;   HL - адрес байта карты освещения
;   C  - маска выбранных двухбитных полей
; Out:
; Corrupt:
;   AF, DE
; -----------------------------------------
.LightmapMergeLevel1
                ; расчёт младших битов результата из старших битов исходных пар
                LD A, (HL)
                LD D, A
                AND #AA
                RRCA
                AND C
                LD E, A

                ; сброс старших битов выбранных пар с сохранением уровней 0 и 1
                LD A, C
                AND #AA
                CPL
                AND D
                OR E
                LD (HL), A
                RET
; -----------------------------------------
; объединение выбранных пар с уровнем света 2
; In:
;   HL - адрес байта карты освещения
;   C  - маска выбранных двухбитных полей
; Out:
; Corrupt:
;   AF, D
; -----------------------------------------
.LightmapMergeLevel2
                ; преобразование уровня 3 в уровень 2 с сохранением более ярких уровней
                LD A, (HL)
                LD D, A
                AND #AA
                RRCA
                AND C
                CPL
                AND D
                LD (HL), A
                RET

.LightmapCenterX       DB #00
.LightmapCenterY       DB #00
.LightmapRowY          DB #00
.LightmapSpanLeftByte  DB #00
.LightmapSpanRightByte DB #00
.LightmapSpanEndMask   DB #00

                ; таблица профилей радиуса в экранных знакоместах
                ; профиль 7 точно повторяет прежние границы max(5*|x|, 2*|x|+6*|y|), остальные пропорционально уменьшены
.LightmapProfileTable
                DW .LightmapProfile1
                DW .LightmapProfile2
                DW .LightmapProfile3
                DW .LightmapProfile4
                DW .LightmapProfile5
                DW .LightmapProfile6
                DW .LightmapProfile7

                ; первое значение профиля задаёт вертикальное смещение верхней строки
                ; каждая строка содержит половины ширины внешней, средней и внутренней хорд
                ; #FF вместо ширины означает отсутствие хорды текущего уровня
.LightmapProfile1
                DB 1
                DB 0, #FF, #FF
                DB 1,   1,   0
                DB 0, #FF, #FF
                DB #FF

.LightmapProfile2
                DB 2
                DB 1, #FF, #FF
                DB 3,   2, #FF
                DB 3,   2,   0
                DB 3,   2, #FF
                DB 1, #FF, #FF
                DB #FF

.LightmapProfile3
                DB 3
                DB 2, #FF, #FF
                DB 4,   2, #FF
                DB 4,   3,   0
                DB 4,   3,   1
                DB 4,   3,   0
                DB 4,   2, #FF
                DB 2, #FF, #FF
                DB #FF

.LightmapProfile4
                DB 5
                DB 0, #FF, #FF
                DB 3, #FF, #FF
                DB 6,   2, #FF
                DB 6,   4, #FF
                DB 6,   4,   1
                DB 6,   4,   1
                DB 6,   4,   1
                DB 6,   4, #FF
                DB 6,   2, #FF
                DB 3, #FF, #FF
                DB 0, #FF, #FF
                DB #FF

.LightmapProfile5
                DB 6
                DB 1, #FF, #FF
                DB 4, #FF, #FF
                DB 7,   2, #FF
                DB 7,   5, #FF
                DB 7,   5, #FF
                DB 7,   5,   2
                DB 7,   5,   2
                DB 7,   5,   2
                DB 7,   5, #FF
                DB 7,   5, #FF
                DB 7,   2, #FF
                DB 4, #FF, #FF
                DB 1, #FF, #FF
                DB #FF

.LightmapProfile6
                DB 7
                DB 2, #FF, #FF
                DB 5, #FF, #FF
                DB 8,   2, #FF
                DB 9,   5, #FF
                DB 9,   6, #FF
                DB 9,   6,   0
                DB 9,   6,   2
                DB 9,   6,   2
                DB 9,   6,   2
                DB 9,   6,   0
                DB 9,   6, #FF
                DB 9,   5, #FF
                DB 8,   2, #FF
                DB 5, #FF, #FF
                DB 2, #FF, #FF
                DB #FF

.LightmapProfile7
                DB 8
                DB  3, #FF, #FF
                DB  6, #FF, #FF
                DB  9,   1, #FF
                DB 10,   4, #FF
                DB 10,   7, #FF
                DB 10,   7, #FF
                DB 10,   7,   1
                DB 10,   7,   3
                DB 10,   7,   3
                DB 10,   7,   3
                DB 10,   7,   1
                DB 10,   7, #FF
                DB 10,   7, #FF
                DB 10,   4, #FF
                DB  9,   1, #FF
                DB  6, #FF, #FF
                DB  3, #FF, #FF
                DB #FF

                endif ; ~_OBJECT_LIGHTMAP_
