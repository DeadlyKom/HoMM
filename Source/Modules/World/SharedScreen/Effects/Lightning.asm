                ifndef _WORLD_SCREEN_EFFECTS_LIGHTNING_
                define _WORLD_SCREEN_EFFECTS_LIGHTNING_

                module Lightning
; -----------------------------------------
; случайные серии грозы и атрибутные вспышки игрового окна
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   включена страница 7, вызов после переноса кадра и восстановления фона курсора
;   интервалы отсчитываются по TickCounterRef, разрешение прерываний не изменяется
;   исходные атрибуты берутся с основного экрана, пиксели обоих экранов не изменяются
;   за один вызов выполняется не более одного перехода между фазами
; -----------------------------------------
Tick:           ; чтение общего счётчика прерываний
                LD HL, (TickCounterRef)

                ; проверка первого вызова после развёртывания кода мира
                LD A, (Started)
                OR A
                JR NZ, .Elapsed                                                 ; переход, если начальное значение счётчика уже сохранено

                LD (LastTick), HL
                LD A, 1
                LD (Started), A
                JP .Display

.Elapsed        ; расчёт интервала после предыдущего вызова с учётом переполнения счётчика
                LD DE, (LastTick)
                LD (LastTick), HL
                OR A
                SBC HL, DE
                EX DE, HL

                ; расчёт остатка времени текущей фазы
                LD HL, (Timer)
                OR A
                SBC HL, DE
                JR C, .Advance                                                  ; переход, если прошедший интервал превысил остаток времени

                LD (Timer), HL
                LD A, H
                OR L
                JR NZ, .Display                                                 ; переход, если время текущей фазы ещё не закончилось

.Advance        CALL Advance
.Display        ; проверка необходимости наложить чёрно-белую фазу вспышки
                LD A, (Attribute)
                CP STORM_NORMAL
                JR Z, .Normal                                                   ; переход, если должны отображаться исходные цвета мира

                LD HL, Painted
                LD (HL), 1
                JP Fill

.Normal         ; проверка наличия атрибутной вспышки на теневом экране
                LD A, (Painted)
                OR A
                RET Z                                                           ; выход, если исходные цвета уже отображаются

                ; восстановление цветов после завершения импульса
                XOR A
                LD (Painted), A
                JP Restore

; -----------------------------------------
; переход между фазами вспышки и периодами активности грозы
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Advance:        ; проверка завершения ожидания перед очередной вспышкой
                LD A, (Phase)
                OR A
                JR NZ, .NextPhase                                               ; переход, если уже проигрывается последовательность вспышки

                ; проверка начала новой активной серии грозы
                LD A, (StormActive)
                OR A
                JR NZ, .Begin                                                   ; переход, если активная серия уже началась

                ; выбор количества вспышек новой активной серии
                LD A, 1
                LD (StormActive), A
                CALL World.SharedScreen.Effects.Rain.Random
                AND STORM_NUM_MASK
                ADD A, STORM_NUM_MIN
                LD (BurstsLeft), A
.Begin          LD A, 1
                JR .LoadPhase

.NextPhase      ; расчёт номера следующей фазы вспышки
                INC A
                CP STORM_PHASES + 1
                JR NC, .Finish                                                  ; переход, если последовательность вспышки завершена

                ; проверка паузы перед возможным повторным импульсом
                CP 3
                JR NZ, .LoadPhase                                               ; переход, если очередная фаза не является паузой перед повтором

                ; случайный выбор одиночной или двойной вспышки
                CALL World.SharedScreen.Effects.Rain.Random
                AND 1
                JR Z, .Finish                                                   ; переход, если повторный импульс не выбран

                LD A, 3
.LoadPhase      ; чтение длительности и атрибута выбранной фазы
                LD (Phase), A
                DEC A
                LD C, A
                ADD A, A
                ADD A, C
                LD HL, .Sequence
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                LD A, (HL)
                LD (Timer), DE
                LD (Attribute), A
                RET

.Finish         ; завершение вспышки и возврат исходных цветов
                XOR A
                LD (Phase), A
                LD A, STORM_NORMAL
                LD (Attribute), A

                ; проверка оставшихся вспышек в активной серии
                LD HL, BurstsLeft
                DEC (HL)
                JR Z, .EndStorm                                                 ; переход, если все вспышки активной серии проиграны

                ; выбор интервала до следующей вспышки активной грозы
                CALL World.SharedScreen.Effects.Rain.Random
                AND STORM_GAP_MASK
                ADD A, STORM_GAP_MIN
                LD L, A
                LD H, 0
                LD (Timer), HL
                RET

.EndStorm       ; завершение активной серии и выбор паузы до следующей грозы
                XOR A
                LD (StormActive), A
                CALL World.SharedScreen.Effects.Rain.Random
                AND STORM_OFF_MASK
                LD E, A
                LD D, 0
                LD HL, STORM_OFF_MIN
                ADD HL, DE
                LD (Timer), HL
                RET

                ; последовательность пар длительность в прерываниях и атрибут окна
.Sequence       DW STORM_PEAK_TICK                                              ; первый яркий импульс
                DB STORM_PEAK_ATTR
                DW STORM_FADE_TICK                                              ; тусклая фаза после первого импульса
                DB STORM_FADE_ATTR
                DW STORM_WAIT_TICK                                              ; пауза в исходных цветах перед повторным импульсом
                DB STORM_NORMAL
                DW STORM_PEAK_TICK                                              ; повторный яркий импульс
                DB STORM_PEAK_ATTR
                DW STORM_FADE_TICK                                              ; тусклая фаза после повторного импульса
                DB STORM_FADE_ATTR

; -----------------------------------------
; наложение атрибута вспышки только на игровое окно теневого экрана
; In:
;   A - атрибут текущей фазы
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Fill:           ; получение адреса левого верхнего атрибута игрового окна
                SCREEN_ATTR_ADR_REG HL, SCR_ADR_SHADOW, SCR_WORLD_POS_X, SCR_WORLD_POS_Y
                LD B, SCR_WORLD_SIZE_Y
.Row            PUSH BC
                LD C, SCR_WORLD_SIZE_X
.Column         LD (HL), A
                INC HL
                DEC C
                JR NZ, .Column                                                  ; переход, если в строке остались атрибуты игрового окна

                ; расчёт начала следующей строки игрового окна
                LD DE, 32 - SCR_WORLD_SIZE_X
                ADD HL, DE
                POP BC
                DJNZ .Row
                RET

; -----------------------------------------
; восстановление актуальных цветов мира с основного экрана на теневой
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Restore:        ; получение адресов исходных и отображаемых атрибутов игрового окна
                SCREEN_ATTR_ADR_REG HL, SCR_ADR_BASE, SCR_WORLD_POS_X, SCR_WORLD_POS_Y
                SCREEN_ATTR_ADR_REG DE, SCR_ADR_SHADOW, SCR_WORLD_POS_X, SCR_WORLD_POS_Y
                LD A, SCR_WORLD_SIZE_Y
.Row            LD BC, SCR_WORLD_SIZE_X
                LDIR

                ; расчёт начала следующей строки на обоих экранах
                LD BC, 32 - SCR_WORLD_SIZE_X
                ADD HL, BC
                EX DE, HL
                ADD HL, BC
                EX DE, HL
                DEC A
                JR NZ, .Row                                                     ; переход, если остались строки атрибутов игрового окна

                RET

                ; состояние грозы размещается вместе с кодом в существующей области страницы 7
Started         DB 0                                                            ; признак первого чтения счётчика прерываний
LastTick        DW 0                                                            ; номер прерывания предыдущего вызова
Timer           DW STORM_OFF_MIN                                                ; остаток времени текущей фазы или паузы в прерываниях
Phase           DB 0                                                            ; номер фазы вспышки, 0 ожидание, 1..5 импульсы и пауза
StormActive     DB 0                                                            ; признак активной серии грозы, 0 пауза между сериями
BurstsLeft      DB 0                                                            ; количество оставшихся вспышек активной серии
Attribute       DB STORM_NORMAL                                                 ; текущий атрибут вспышки или признак исходных цветов
Painted         DB 0                                                            ; признак наложенной вспышки, 0 исходные цвета, 1 требуется восстановление

                endmodule
                endif                                                           ; ~_WORLD_SCREEN_EFFECTS_LIGHTNING_
