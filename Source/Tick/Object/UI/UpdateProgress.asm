
                ifndef _TICK_OBJECT_UI_UPDATE_PROGRESS_
                define _TICK_OBJECT_UI_UPDATE_PROGRESS_
; -----------------------------------------
; обновление прогресса UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   DE - адрес структуры настроек (FUISettings_Progress)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   флаг переполнения установлен, если фаза завершена
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   Progress увеличивается с насыщением до #FF
;   результат функции преобразования масштабируется через Lerp8 диапазоном
;   соответствующей оси и записывается в разрешённые AxisOffset
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.UpdateProgress:; получение шага прогресса
                EX DE, HL                                                       ; HL - адрес структуры FUISettings_Progress
                LD B, (HL)                                                      ; FUISettings_Progress.Step

                ; применение относительного временного шага: x1, x2 или x4
                LD A, #02
                SUB C
                LD (.Jump), A
                LD A, B
.Jump           EQU $+1
                JR $
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

.Increment      ; увеличение прогресса с насыщением до #FF
                ADD A, B
                JR C, .Saturate                                                 ; переход, если Progress превысил #FF
                CP #FF
                JR Z, .Complete                                                 ; переход, если Progress достиг #FF
                JR .Store

.Decrement      ; уменьшение прогресса с насыщением до #00
                ADD A, B                                                        ; прибавление отрицательного Step
                JR NC, .Saturate                                                ; переход, если Progress стал меньше #00
                OR A
                JR Z, .Complete                                                 ; переход, если Progress достиг #00

.Store          ; сохранение прогресса
                LD (IX + FObjectUI.Progress), A

                ; обновление осей
                CALL .UpdateAxisOffsets
                CALL UI.MarkDirty
                OR A                                                            ; сброс флага переполнения, фаза не завершена
                RET

.Saturate       SBC A, A                                                        ; #FF при превышении верхней границы, #00 при выходе ниже нуля

.Complete       ; сохранение прогресса
                LD (IX + FObjectUI.Progress), A

                ; обновление осей
                CALL .UpdateAxisOffsets
                CALL UI.MarkDirty
                SCF                                                             ; установка флага переполнения, фаза завершена
                RET
; -----------------------------------------
; обновление разрешённых смещений осей
; In:
;   A  - Progress (0..255)
;   HL - адрес структуры FUISettings_Progress
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; ----------------------------------------
.UpdateAxisOffsets:
                LD B, A                                                         ; сохранение Progress
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
                INC HL                                                          ; пропуск FUISettings_Progress.AxisY.A
                INC HL                                                          ; пропуск FUISettings_Progress.AxisY.B
                INC HL                                                          ; переход к FUISettings_Progress.AxisX.A
                LD D, (HL)                                                      ; значение A для AxisOffset.X
                INC HL                                                          ; переход к FUISettings_Progress.AxisX.B
                LD E, (HL)                                                      ; значение B для AxisOffset.X
                CALL Math.Lerp8

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
.ApplyAxisFunc: ifdef _DEBUG
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
