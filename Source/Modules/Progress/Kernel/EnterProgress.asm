
                ifndef _MODULE_PROGRESS_ENTER_PROGRESS_
                define _MODULE_PROGRESS_ENTER_PROGRESS_
; -----------------------------------------
; продвижение до указанного процента
; In:
;   SP+0 - конечное значение прогресса в формате fixed-point 8.8
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   обратное движение прогресса не выполняется
; -----------------------------------------
ProgressToPer   POP HL                                                          ; чтение конечного значения прогресса
                LD BC, (Kernel.Modules.Progress.CurrentPercent)
                OR A
                SBC HL, BC                                                      ; шаг до указанного процента
                RET C                                                           ; выход, если конечное значение меньше текущего
                PUSH HL                                                         ; передача шага в EnterProgress
; -----------------------------------------
; продвижение прогресса
; In:
;   SP+0 - шаг прогресса в формате fixed-point 8.8 (параметр, переданный через BC)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   старший байт текущего значения является индексом в таблице этапов
;   конечное значение ограничивается количеством записей в таблице
; -----------------------------------------
EnterProgress:  POP BC                                                          ; чтение шага прогресса
                
                ifdef ENABLE_LOADING_PROCESS
                ; чтение текущего значения и сохранение начального индекса
                LD HL, (Kernel.Modules.Progress.CurrentPercent)                 ; текущее значение fixed-point 8.8
                LD A, H

                ; прибавление шага с ограничением по концу таблицы
                ADD HL, BC
                LD DE, UI.Graphics.Progress.Strip.Num << 8
                OR A
                SBC HL, DE
                JR NC, .SetMaximum                                              ; переход, если достигнут конец таблицы
                ADD HL, DE                                                      ; восстановление конечного значения
                JR .SaveCurrent
.SetMaximum     LD HL, UI.Graphics.Progress.Strip.Num << 8

.SaveCurrent    ; расчёт количества выполняемых проходов
                ;   A - текущий индекс
                ;   H - конечный индекс
                LD C, A
                LD A, H                                                         ; конечный индекс
                SUB C
                RET C                                                           ; выход, если дельта отрицательная
                LD (Kernel.Modules.Progress.CurrentPercent), HL                 ; сохранение конечного значения
                RET Z                                                           ; выход, если рисование не требуется

                LD B, A

                ; расчёт адреса текущей записи таблицы
                LD A, C
                ADD A, A    ; х2
                LD L, A
                LD H, #00
                LD DE, Initialize.Strip
                ADD HL, DE

.DrawLoop       HALT                                                            ; синхронизация перед выводом

                ; чтение смещения до графики этапа
                LD E, (HL)
                INC HL
                LD D, (HL)

                PUSH HL                                                         ; сохранение адреса старшего байта смещения
                ADD HL, DE                                                      ; получение адреса графики этапа
                PUSH BC                                                         ; сохранение счётчика проходов
                CALL Draw.SpriteNotBound                                        ; отображение достигнутого этапа
                POP BC                                                          ; восстановление счётчика проходов

                ; переход к следующей записи таблицы
                POP HL
                INC HL
                DJNZ .DrawLoop

                DELAY 2                                                         ; ToDo: временно
                RET
; -----------------------------------------
; сброс состояния прогресса
; In:
; Out:
; Corrupt:
;   AF
; Note:
; -----------------------------------------
.Reset          XOR A
                LD (Kernel.Modules.Progress.CurrentPercent), A
                LD (Kernel.Modules.Progress.CurrentPercent + 1), A
                endif
                RET

                endif ; ~_MODULE_PROGRESS_ENTER_PROGRESS_
