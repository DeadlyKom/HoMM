
                ifndef _TICK_OBJECT_UI_UPDATE_PROGRESS_
                define _TICK_OBJECT_UI_UPDATE_PROGRESS_
; -----------------------------------------
; обновление прогресса UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   DE - адрес структуры настроек (FUISettings_Progress)
;   C  - диапазон cadence: 0 - 1/2, 1 - 1/4, 2 - 1/8
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   флаг переполнения установлен, если фаза завершена
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   Progress изменяется с насыщением до границы диапазона и формирует
;   целевое значение смещения разрешённых осей
;
;   при включённом ENABLE_UI_PROGRESS_DURATION:
;     - AlphaCounter отражает прошедшее время интерполяции;
;     - временной шаг рассчитывается с учётом диапазона cadence;
;     - фактический AxisOffset интерполируется от значения A диапазона
;       к целевому значению, рассчитанному из Progress
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.UpdateProgress:; получение шага прогресса
                EX DE, HL                                                       ; HL - адрес структуры FUISettings_Progress
                LD B, (HL)                                                      ; FUISettings_Progress.Step

                ; расчёт временного шага: x1, x2 или x4
                LD A, #02
                SUB C
                LD (.Jump), A
                LD A, B
.Jump           EQU $+1
                JR NZ, $
                ADD A, A  ; x4
                ADD A, A  ; x2
                LD B, A                                                         ; шаг прогресса с учётом частоты cadence-диапазона

.Update         ; ----------------------------------------
                ; обновление прогресса
                ; ----------------------------------------
                LD A, (IX + FObjectUI.Progress)

                ; определение направления изменения прогресса
                BIT 7, B
                JR NZ, .Decrement                                               ; переход, если Step отрицательный

.Increment      ; увеличение прогресса с ограничением до #FF
                ADD A, B
                JR NC, .StoreProgress                                           ; переход, если Progress не превысил #FF
                SBC A, A                                                        ; #FF при превышении верхней границы
                JR .StoreProgress

.Decrement      ; уменьшение прогресса с ограничением до #00
                ADD A, B                                                        ; прибавление отрицательного Step
                JR C, .StoreProgress                                            ; переход, если Progress не стал меньше #00
                XOR A                                                           ; #00 при выходе ниже нижней границы

.StoreProgress  ; сохранение целевого прогресса
                LD (IX + FObjectUI.Progress), A

                ifdef ENABLE_UI_PROGRESS_DURATION
                ; ----------------------------------------
                ; обновление счётчика времени интерполяции
                ; ----------------------------------------
                INC HL                                                          ; переход к FUISettings_Progress.Duration
                LD E, (HL)                                                      ; длительность интерполяции
                LD A, E

                ; проверка дополнительной интерполяции
                OR A
                JR Z, .AlphaImmediate                                           ; переход, если дополнительная интерполяция выключена

                ; расчёт временного шага: x1, x2 или x4
                LD A, #02
                SUB C
                LD (.AlphaJump), A
                LD A, #01
.AlphaJump      EQU $+1
                JR NZ, $
                ADD A, A  ; x4
                ADD A, A  ; x2
                LD B, A                                                         ; относительный временной шаг AlphaCounter

                ; увеличение AlphaCounter временным шагом
                LD A, (IX + FObjectUI.AlphaCounter)
                ADD A, B
                JR C, .AlphaLimit                                               ; переход, если AlphaCounter превысил #FF

                ; проверка достижения длительности интерполяции
                CP E
                JR C, .StoreAlpha                                               ; переход, если Duration ещё не достигнута

.AlphaLimit     LD A, E                                                         ; ограничение AlphaCounter длительностью интерполяции
.StoreAlpha     LD (IX + FObjectUI.AlphaCounter), A                             ; сохранение счётчика времени интерполяции

                ; нормализация AlphaCounter из диапазона 0..Duration к 0..255
                PUSH HL                                                         ; адрес FUISettings_Progress.Duration
                CALL Math.NormalizeScal
                EXX
                LD B, A                                                         ; нормализованная Alpha
                EXX
                POP HL
                JR .UpdateAxes

.AlphaImmediate EXX
                LD B, #FF                                                       ; нормализованная Alpha = 1, дополнительная интерполяция выключена
                EXX
                LD (IX + FObjectUI.AlphaCounter), #00                           ; сброс неиспользуемого счётчика

.UpdateAxes     ; обновление разрешённых осей
                DEC HL                                                          ; переход к FUISettings_Progress.Step
                endif

                ; обновление разрешённых осей
                LD A, (IX + FObjectUI.Progress)
                PUSH HL                                                         ; адрес FUISettings_Progress.Step
                CALL .UpdateAxisOffsets
                CALL UI.MarkDirty
                POP HL

                ifdef ENABLE_UI_PROGRESS_DURATION
                ; проверка завершения интерполяции
                INC HL                                                          ; переход к FUISettings_Progress.Duration
                LD A, (IX + FObjectUI.AlphaCounter)
                CP (HL)
                JR NZ, .NotComplete                                             ; переход, если AlphaCounter ещё не достиг Duration

                ; проверка достижения Progress требуемой границы
                DEC HL                                                          ; переход к FUISettings_Progress.Step
                endif

                ; проверка достижения Progress требуемой границы
                BIT 7, (HL)
                LD A, (IX + FObjectUI.Progress)
                JR NZ, .CheckLowerBound                                         ; переход, если Progress уменьшается

                CP #FF
                JR NZ, .NotComplete                                             ; переход, если верхняя граница ещё не достигнута
                SCF                                                             ; установка флага переполнения, фаза завершена
                RET

.CheckLowerBound; проверка достижения Progress нижней границы
                OR A
                RET NZ                                                          ; выход, если нижняя граница ещё не достигнута

                SCF                                                             ; установка флага переполнения, фаза завершена
                RET

.NotComplete    OR A                                                            ; сброс флага переполнения, фаза не завершена
                RET
; -----------------------------------------
; обновление разрешённых смещений осей
; In:
;   A  - Progress (0..255)
;   HL - адрес структуры FUISettings_Progress
;   B' - нормализованная Alpha (0..255), если включён ENABLE_UI_PROGRESS_DURATION
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; ----------------------------------------
.UpdateAxisOffsets
                LD B, A                                                         ; сохранение Progress
                INC HL                                                          ; переход к FUISettings_Progress.Duration
                INC HL                                                          ; переход к FUISettings_Progress.Flags
                LD C, (HL)
                INC HL                                                          ; переход к FUISettings_Progress.AxisFunctions
                LD D, (HL)

                ; ----------------------------------------
                ; обновление смещения по вертикали
                ; ----------------------------------------

                ; проверка изменения оси Y
                BIT UI_PROGRESS_AXIS_Y_BIT, C
                JR Z, .AxisX                                                    ; переход, если обновление оси запрещено

                ; определение функции
                LD A, D
                AND UI_AXIS_FUNCTION_MASK

                ; применение функции преобразования Progress
                PUSH BC                                                         ; Progress и флаги обновляемых осей
                PUSH DE                                                         ; функции преобразования осей
                PUSH HL                                                         ; адрес FUISettings_Progress.AxisFunctions
                CALL .ApplyAxisFunc
                POP HL

                ; масштабирование результата диапазоном оси Y
                PUSH HL
                INC HL                                                          ; переход к FUISettings_Progress.AxisY.A
                LD D, (HL)                                                      ; значение A для AxisOffset.Y
                INC HL                                                          ; переход к FUISettings_Progress.AxisY.B
                LD E, (HL)                                                      ; значение B для AxisOffset.Y
                CALL Math.Lerp8
                POP HL

                ifdef ENABLE_UI_PROGRESS_DURATION
                ; интерполяция от начала диапазона к целевому смещению
                LD E, A                                                         ; целевое значение AxisOffset.Y
                PUSH HL
                INC HL                                                          ; переход к FUISettings_Progress.AxisY.A
                LD D, (HL)                                                      ; начальное значение AxisOffset.Y
                EXX
                LD A, B                                                         ; нормализованная Alpha
                EXX
                CALL Math.Lerp8
                POP HL
                endif
                POP DE
                POP BC

                ; сохранение результата
                LD (IX + FObjectUI.Layer.AxisOffset.Y), A

.AxisX          ; ----------------------------------------
                ; обновление смещения по горизонтали
                ; ----------------------------------------

                ; проверка изменения оси X
                BIT UI_PROGRESS_AXIS_X_BIT, C
                RET Z                                                           ; выход, если обновление оси запрещено

                ; определение функции
                LD A, D
                RRCA
                RRCA
                RRCA
                RRCA                                                            ; функция преобразования для AxisOffset.X
                AND UI_AXIS_FUNCTION_MASK

                ; применение функции преобразования Progress
                PUSH HL
                CALL .ApplyAxisFunc
                POP HL

                ; масштабирование результата диапазоном оси X
                PUSH HL                                                         ; адрес FUISettings_Progress.AxisFunctions
                INC HL                                                          ; пропуск FUISettings_Progress.AxisY.A
                INC HL                                                          ; пропуск FUISettings_Progress.AxisY.B
                INC HL                                                          ; переход к FUISettings_Progress.AxisX.A
                LD D, (HL)                                                      ; значение A для AxisOffset.X
                INC HL                                                          ; переход к FUISettings_Progress.AxisX.B
                LD E, (HL)                                                      ; значение B для AxisOffset.X
                CALL Math.Lerp8
                POP HL                                                          ; адрес FUISettings_Progress.AxisFunctions

                ifdef ENABLE_UI_PROGRESS_DURATION
                ; интерполяция от начала диапазона к целевому смещению
                LD E, A                                                         ; целевое значение AxisOffset.X
                PUSH HL
                INC HL                                                          ; пропуск FUISettings_Progress.AxisY.A
                INC HL                                                          ; пропуск FUISettings_Progress.AxisY.B
                INC HL                                                          ; переход к FUISettings_Progress.AxisX.A
                LD D, (HL)                                                      ; начальное значение AxisOffset.X
                EXX
                LD A, B                                                         ; нормализованная Alpha
                EXX
                CALL Math.Lerp8
                POP HL
                endif

                ; сохранение результата
                LD (IX + FObjectUI.Layer.AxisOffset.X), A
                RET
; -----------------------------------------
; применение функции преобразования Progress
; In:
;   A - индекс функции преобразования
;   B - Progress (0..255)
; Out:
;   A - преобразованное значение (0..255)
; Corrupt:
;   HL, DE, AF
; Note:
; ----------------------------------------
.ApplyAxisFunc  ifdef _DEBUG
                CP UI_AXIS_FUNCTION_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такой функции преобразования Progress
                endif

                DEC A                                                           ; UI_AXIS_FUNCTION_EASE_IN
                JR Z, .EaseIn
                DEC A                                                           ; UI_AXIS_FUNCTION_EASE_OUT
                JR Z, .EaseOut
                DEC A                                                           ; UI_AXIS_FUNCTION_EASE_IN_OUT
                JR Z, .EaseInOut

.None           LD A, B                                                         ; применение Progress без преобразования
                RET

.EaseIn         ; ----------------------------------------
                ; EaseIn(t) = 1 - EaseOut(1 - t)
                ;
                ; для диапазона 0..255:
                ; EaseIn(t) = 255 - EaseOut(255 - t)
                ; ----------------------------------------
                LD A, B
                CPL                                                             ; A = 255 - Progress
                CALL Math.EaseOut
                CPL                                                             ; A = 255 - EaseOut(255 - Progress)
                RET

.EaseOut        LD A, B
                JP Math.EaseOut

.EaseInOut      ; ----------------------------------------
                ; первая половина:
                ;   EaseInOut(t) = EaseIn(2t) / 2
                ;
                ; вторая половина:
                ;   EaseInOut(t) = 128 + EaseOut(2(t - 128)) / 2
                ; ----------------------------------------
                LD A, B
                BIT 7, A
                JR NZ, .EaseInOutUpper                                          ; переход ко второй половине функции

                ADD A, A                                                        ; A = 2 * Progress
                CPL
                CALL Math.EaseOut
                CPL                                                             ; A = EaseIn(2 * Progress)
                SRL A                                                           ; A = EaseIn(2 * Progress) / 2
                RET

.EaseInOutUpper SUB #80                                                         ; A = Progress - 128
                ADD A, A                                                        ; A = 2 * (Progress - 128)
                CALL Math.EaseOut
                SRL A                                                           ; A = EaseOut(2 * (Progress - 128)) / 2
                ADD A, #80                                                      ; A = 128 + EaseOut(...) / 2
                RET

                endif ; ~_TICK_OBJECT_UI_UPDATE_PROGRESS_
