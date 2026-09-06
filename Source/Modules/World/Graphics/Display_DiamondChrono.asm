                ifndef _MODULE_WORLD_DISPLAY_DIAMOND_CHRONO_
                define _MODULE_WORLD_DISPLAY_DIAMOND_CHRONO_
DiamondChrono:
; -----------------------------------------
; инициализация
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, DE'
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
.Initialize     ; сброс сохранённой фазы для обязательной начальной отрисовки
                LD HL, #FFFF
                LD (.LastPhase), HL
; -----------------------------------------
; отображение фазы суток по игровому календарю
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, DE'
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
.Display        ; обработка запроса обновления фазы суток
                RES_WORLD_CHRONO_FLAG WORLD_DAY_PHASE_UPDATE_BIT                ; сброс запроса обновления фазы суток

                ; расчёт текущей фазы суток по игровому календарю
                CALL .CalcPhase
.LastPhase      EQU $+1
                LD DE, #FFFF

                ; проверка изменения фазы суток
                OR A
                SBC HL, DE
                RET Z                                                           ; выход, если текущая фаза уже отображена

                ; восстановление и сохранение фазы текущей отрисовки
                ADD HL, DE
                LD (.LastPhase), HL

                ; совмещение тёмного центра градиента с полуночью и светлого с полуднем
                ; смещение 256 - 23 учитывает положение центра ромба в экранном окне
                LD DE, #00E9
                ADD HL, DE
                RES 1, H

                ; преобразование половины цикла во флаг направления
                LD A, H
                RRCA
                LD A, L
                LD HL, (Kernel.Modules.World.MemoryAddress)
                CALL DiamondTexture                                             ; отображение новой фазы на основном экране

                ; установка запроса переноса обновлённого ромба
                SET_FLAG_MODIFY World.Base.Render.PipelineHexagons.DiamondFlag
                RET
; -----------------------------------------
; расчёт фазы суток по текущему времени "мира"
; In:
; Out:
;   HL - фаза суток 0..511, начало отсчёта в 00:00
; Corrupt:
;   DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
;   WorldTick содержит остаток тиков 1..WORLD_TICKS_PER_HOUR
;   фаза = (64 * час + (64 * прошедшие тики / тики в час)) / 3
;   оба деления целочисленные, накопления округлений нет
; -----------------------------------------
.CalcPhase      ; расчёт числа прошедших тиков текущего часа
                LD HL, WORLD_TICKS_PER_HOUR
                LD DE, (GameSession.WorldTime + FWorldTime.WorldTick)
                OR A
                SBC HL, DE

                ; расчёт доли часа в диапазоне 0..63 без переполнения произведения
                LD DE, WORLD_TICKS_PER_HOUR
                LD BC, #0600
.Fraction       SLA C
                ADD HL, HL

                ; проверка выхода удвоенного остатка за пределы 16 бит
                JR C, .FracHigh                                                 ; переход, если удвоенный остаток превышает 65535

                ; расчёт остатка после выделения очередного разряда доли часа
                SBC HL, DE

                ; проверка значения очередного разряда
                JR NC, .FracOne                                                 ; переход, если очередной разряд доли часа равен единице
                ADD HL, DE
                JR .FracNext

.FracHigh       ; расчёт остатка с учётом старшего разряда удвоенного значения
                OR A
                SBC HL, DE
.FracOne        INC C
.FracNext       DJNZ .Fraction

                ; чтение часов в диапазоне 0..23
                LD A, (GameSession.WorldTime + FWorldTime.Hour)

                ; расчёт времени суток в долях часа размером 1/64
                LD H, #00
                LD L, A
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                ADD HL, HL  ; x64
                LD D, #00
                LD E, C
                ADD HL, DE

                ; расчёт фазы цикла из 512 шагов за 24 часа
                ; делимое 0..1535, B = 0 после расчёта доли часа
                ; проверка принадлежности фазы второй половине суток
                LD A, H
                SUB #03
                JR C, .PhaseLow                                                 ; переход, если время меньше 12 часов

                ; вычитание половины суток и установка старшего бита фазы
                LD H, A
                INC B

.PhaseLow       ; проверка необходимости коррекции делимого
                BIT 1, H
                JR Z, .PhaseMul                                                 ; переход, если делимое меньше 512

                ; уменьшение делимого 512..767 для точного деления на 3
                DEC HL

.PhaseMul       ; расчёт произведения скорректированного делимого на 85
                LD D, H
                LD E, L
                ADD HL, HL
                ADD HL, HL
                ADD HL, DE
                ADD HL, HL
                ADD HL, HL
                ADD HL, DE
                ADD HL, HL
                ADD HL, HL
                ADD HL, DE

                ; добавление половины скорректированного делимого
                SRL D
                RR E
                ADD HL, DE

                ; получение младшего байта фазы делением суммы на 256
                LD L, H
                LD H, B
                RET

                endif                                                           ; ~_MODULE_WORLD_DISPLAY_DIAMOND_CHRONO_
