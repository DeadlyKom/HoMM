
                ifndef _UI_UPDATE_
                define _UI_UPDATE_
; -----------------------------------------
; обновление UI
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в Kernel
; -----------------------------------------
Update:         ; проверка блокировки обновления UI
                CHECK_UI_FLAG_A UI_UPDATE_DISABLE_BIT
                RET NZ                                                          ; выход, если блокировка обновления UI включена

                ; проверка количества активных слоёв
                LD A, (GameState.UIRuntime + FUIRuntime.LayersNum)
                OR A
                RET Z                                                           ; выход, если активные слои отсутствуют

                EX AF, AF'                                                      ; сохранение количество слоёв

                ; проверка клавиши "выбор" один раз перед обходом элементов
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState

                ; подготовка кода команды сброса или установки состояния нажатия
                LD A, #B6                                                       ; RES UI_STATE_PRESSED_BIT,(IY + FUIElement.FLags)
                JR NZ, $+4                                                      ; переход, если клавиша отпущена
                LD A, #F6                                                       ; SET UI_STATE_PRESSED_BIT,(IY + FUIElement.FLags)
                LD (Update.Pressed), A

                EX AF, AF'                                                      ; восстаовление количество слоёв

                ; инициализация
                LD B, A
                LD HL, (GameState.UIRuntime + FUIRuntime.LayerAdr)
                RES_FLAG_MODIFY Update.Flag                                     ; сброс флага найденного перекрытия

.LayerLoop      ; основной цикл обхода слои (FUILayer)
                BIT LAYER_UI_VISIBLE_BIT, (HL)
                JR Z, .NextLayer

                PUSH HL
                PUSH BC
                INC HL

                ; чтение количество элементов в массиве
                LD B, (HL)
                INC HL

                ; чтение адреса массива элементов UI
                LD A, (HL)
                LD IYL, A
                INC HL
                LD A, (HL)
                LD IYH, A

.UILoop         ; цикл обхода элементов UI (FUIElement)
                LD A, (IY + FUIElement.FLags)

                ; проверка видимости элемента
                BIT UI_VISIBLE_BIT, A
                JR Z, .NextUI                                                   ; переход, если элемент скрыт

                ; проверка доступности элемента
                BIT UI_ENABLED_BIT, A
                JR Z, .NextUI                                                   ; переход, если элемент недоступен

                ; обновление состояния нажатия для видимого доступного элемента
.Pressed        EQU $+3
                RES UI_STATE_PRESSED_BIT, (IY + FUIElement.FLags)

                ; сохранение адреса элемента и счётчика обхода на время вызова обработчика
                PUSH IY
                PUSH BC

                ; чтение адреса обработчика
                LD A, (IY + FUIElement.OnUpdate + 0)
                LD IXL, A
                LD A, (IY + FUIElement.OnUpdate + 1)
                LD IXH, A

                ; проверка пересечения курсором области UI
                LD DE, (IY + FUIElement.Location)                               ; чтение положения элемента на экране
                LD BC, (IY + FUIElement.Size)                                   ; чтение размера элемента
                CALL IsInRect
                JR NC, .InSide                                                  ; переход, если курсор находится в области элемента

                ; проверка предыдущего состояния наведения элемента
                BIT UI_STATE_HOVER_BIT, (IY + FUIElement.FLags)
                JR Z, .Restore                                                  ; переход, если элемент уже был вне наведения

                ; сброс состояния наведения при уходе курсора
                RES UI_STATE_HOVER_BIT, (IY + FUIElement.FLags)

                ; вызов обработчика выхода курсора
                CALL .MouseLeave

.Restore        ; восстановление адреса элемента и счётчика обхода
                POP BC
                POP IY

.NextUI         LD DE, FUIElement
                ADD IY, DE
                DJNZ .UILoop

                POP BC
                POP HL

.NextLayer      LD DE, FUILayer
                ADD HL, DE
                DJNZ .LayerLoop

                ; флаг найденного перекрытия
.Flag           EQU $
                NOP
                RET NC                                                          ; выход, если перекрытие не найдены

                ; уменьшить таймер
                LD HL, TooltipTimer
                DEC (HL)
                RET NZ                                                          ; выход, если таймер не нулевой
                
                ; обновим счётчик таймера
                LD (HL), UI_TOOLTIP_HOVER_DELAY

                ; восстановление адреса элемента для обработчика подсказки
.PrevUI         EQU $+2
                LD IY, #0000

                ; вызов обработчика
                OR A                                                            ; сброс флага, для обработчика, сигнализирующий обнуление таймера подсказки
.Prev           EQU $+1
                JP #0000

.InSide         ; проверка предыдущего состояния наведения элемента
                BIT UI_STATE_HOVER_BIT, (IY + FUIElement.FLags)
                CALL Z, .MouseEnter                                             ; вызов обработчика входа, если курсор ранее находился вне элемента

                ; инициализация пересечения области UI
                SET_FLAG_MODIFY Update.Flag                                     ; установка флага найденного перекрытия
                LD (Update.PrevUI), IY                                          ; сохранение адреса элемента для обработчика подсказки

                ; сравнение адресов обработчика, если они отличаются вызвать сброс таймера
                LD BC, (Update.Prev)
                LD (Update.Prev), IX
                PUSH IX
                POP HL
                SBC HL, BC
                CALL NZ, ResetTimer                                             ; сброс таймера, если адрес обработчика изменился

                ; вызов обработчика при наведении курсора
                SCF                                                             ; флаг, вызов обработчика по наведению
                CALL Func.JP_IX
                JR .Restore

.MouseEnter     ; -----------------------------------------
                ; выход из прежнего элемента перед входом в новый
                ; -----------------------------------------
                ; сохранение нового элемента до выхода из прежнего
                PUSH DE
                PUSH IX
                PUSH IY

                ; проверка наличия прежнего элемента под курсором
                LD HL, (Update.PrevUI)                                          ; чтение адреса прежнего элемента
                LD A, H
                OR L
                JR Z, .Enter                                                    ; переход, если прежний элемент отсутствует

                ; проверка состояния наведения прежнего элемента
                PUSH HL
                POP IY
                BIT UI_STATE_HOVER_BIT, (IY + FUIElement.FLags)
                JR Z, .Enter                                                    ; переход, если выход из прежнего элемента уже выполнен

                ; выход из прежнего элемента до входа в новый
                RES UI_STATE_HOVER_BIT, (IY + FUIElement.FLags)
                CALL .MouseLeave

.Enter          ; восстановление нового элемента после выхода из прежнего
                POP IY
                POP IX
                POP DE
                ; -----------------------------------------

                ; установка состояния наведения до вызова обработчика входа
                SET UI_STATE_HOVER_BIT, (IY + FUIElement.FLags)

                ; чтение адреса обработчика входа курсора
                LD HL, (IY + FUIElement.OnMouseEnter)

                ; проверка наличия обработчика входа курсора
                LD A, H
                OR L
                RET Z                                                           ; выход, если обработчик входа не задан

                ; сохранение данных для последующего вызова обработчика обновления
                PUSH DE
                PUSH IX
                PUSH IY
                CALL Func.JP_HL

                ; восстановление данных для обработчика обновления
                POP IY
                POP IX
                POP DE
                OR A                                                            ; сброс флага переполнения для последующего сравнения адресов обработчиков
                RET

.MouseLeave     ; чтение адреса обработчика выхода курсора
                LD HL, (IY + FUIElement.OnMouseLeave)

                ; проверка наличия обработчика выхода курсора
                LD A, H
                OR L
                RET Z                                                           ; выход, если обработчик выхода не задан

                JP (HL)                                                         ; вызов обработчика выхода с возвратом к восстановлению регистров обхода

ResetTimer      LD HL, TooltipTimer
                LD (HL), UI_TOOLTIP_HOVER_DELAY
                RET
; -----------------------------------------
; проверка попадания курсора в область UI
; In:
;   DE - позиция элемента (D - y, E - x)
;   BC - размер элемента (B - y, C - x)
; Out:
;   флаг, переполнения сброшен внутри области и установлен вне области
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в Kernel
; -----------------------------------------
IsInRect:       ; инициализация
                LD HL, Mouse.Position                                           ; ось X
                
                ; проверка по горизонтали
                LD A, (HL)
                CP E
                RET C                                                           ; выход, если курсор находится левее прямоугольнка
 
                LD A, E
                ADD A, C
                DEC A                                                           ; последний допустимый X элемента
                CP (HL)
                RET C                                                           ; выход, если курсор находится правее прямоугольника
                
                INC HL                                                          ; ось Y
                ; проверка по вертикали
                LD A, (HL)
                CP D
                RET C                                                           ; выход, если курсор находится выше прямоугольнка
 
                LD A, D
                ADD A, B
                DEC A                                                           ; последний допустимый Y элемента
                CP (HL)
                RET

                display " - Update UI elements:\t\t\t\t", /A, Update, "\t= busy [ ", /D, $-Update, " byte(s)  ]"

                endif ; ~_UI_UPDATE_
