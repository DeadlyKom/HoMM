
                ifndef _WORLD_TIME_TICK_
                define _WORLD_TIME_TICK_
; -----------------------------------------
; продвижение игрового календаря на один "мировой тик"
; In:
;   IX - адрес структуры FWorldTime
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; ----------------------------------------
Tick:           ; уменьшение числа "мировых тиков" до следующего часа
                LD HL, (IX + FWorldTime.WorldTick)
                DEC HL
                LD A, H
                OR L
                JR Z, .NextHour

                LD (IX + FWorldTime.WorldTick), HL
                RET NZ

.NextHour       ; счётчик исчерпан - начать новый часовой интервал
                LD (IX + FWorldTime.WorldTick.Low), LOW WORLD_TICKS_PER_HOUR
                LD (IX + FWorldTime.WorldTick.High), HIGH WORLD_TICKS_PER_HOUR
                
                LD B, #01

                ; часы [#00..#23]
                LD A, (IX + FWorldTime.Hour)
                ADD A, B
                DAA
                LD (IX + FWorldTime.Hour), A

                CP #24
                RET NZ
                LD (IX + FWorldTime.Hour), #00

                ; упрощённое правило: каждый четвёртый год високосный, включая нулевой
                LD A, (IX + FWorldTime.Years)
                AND #03
                LD HL, .DayTable
                JR NZ, $+5
                LD HL, .LeapDayTable

                ; месяц хранится в пределах [0..11] и является индексом таблицы
                LD E, (IX + FWorldTime.Month)
                LD D, #00
                ADD HL, DE
                LD C, (HL)                                                      ; первый недопустимый день месяца в BCD

                ; дни [#01..#31] BCD
                LD A, (IX + FWorldTime.Day)
                ADD A, B
                DAA
                LD (IX + FWorldTime.Day), A

                CP C
                RET NZ
                LD (IX + FWorldTime.Day), B

                ; месяц хранится в пределах [0..11]
                LD A, E
                ADD A, B
                LD (IX + FWorldTime.Month), A

                CP #0C
                RET NZ
                LD (IX + FWorldTime.Month), D

                ; год
                LD HL, (IX + FWorldTime.Years)
                INC HL
                LD (IX + FWorldTime.Years), HL
                RET

; таблицы хранят в BCD первый недопустимый день каждого месяца
.DayTable       ; обычный год
                DB #32, #29, #32, #31, #32, #31
                DB #32, #32, #31, #32, #31, #32
.LeapDayTable   ; високосный год
                DB #32, #30, #32, #31, #32, #31
                DB #32, #32, #31, #32, #31, #32

                endif ; ~_WORLD_TIME_TICK_
