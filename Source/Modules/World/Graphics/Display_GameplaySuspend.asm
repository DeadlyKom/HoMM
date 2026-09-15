
                ifndef _MODULE_WORLD_DISPLAY_GAMEPLAY_SUSPEND_
                define _MODULE_WORLD_DISPLAY_GAMEPLAY_SUSPEND_
Const.Suspend:  ; константные значения индикатора остановки времени
.PausePosX      EQU 23                                                          ; позиция спрайта "приостановки" по горизонтали в знакоместах
.PausePosY      EQU 0                                                           ; позиция спрайта "приостановки" по вертикали в знакоместах
.MaxFrame       EQU Pause.SpriteInfo.Num                                        ; максимальное количество кадров анимации
; -----------------------------------------
; обновление и отображение индикатора остановки времени
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   необходимо включить страницу модуля "мира"
;   вызывается при включённом режиме остановки времени
;   задержка каждого шага в IRQ задаётся таблицей Const.Suspend.Delay
;   кадр выводится на основной экран в позиции 23, 0 знакомест
;   перенос кадра на теневой экран запрашивается для штатной фазы копирования
;   после отображения восстанавливается исходная страница памяти
; -----------------------------------------
GameplaySuspend:; расчёт адреса задержки текущего шага анимации
                LD A, (.Frame)
                LD L, A
                LD H, #00
                LD DE, .Delay
                ADD HL, DE

                ; расчёт числа IRQ после предыдущего шага анимации
                LD A, (TickCounterRef)
                LD C, A
.LastTick       EQU $+1
                SUB #00

                ; проверка завершения задержки текущего шага
                CP (HL)
                RET C                                                           ; выход, если задержка ещё не завершилась

                ; сохранение номера текущего тика
                LD A, C
                LD (.LastTick), A
                
                ; смена фрейма анимации
                LD HL, .Frame
                DEC (HL)
                JP P, .DrawFrame                                                ; переход, если счётчик кадров неотрицателен
                LD (HL), #01                                                    ; начало цикла двух последних кадров
                
.DrawFrame      ; запрос переноса нового кадра индикатора на теневой экран
                SET_FLAG_MODIFY World.SharedCode.Render.PipelineHexagons.SuspendFlag

                ; чтение текущего кадра анимации
.Frame          EQU $+1
                LD A, Const.Suspend.MaxFrame

                ; расчёт адреса описания выбранного кадра
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD L, A
                LD H, #00
                LD DE, Pause.SpriteInfo
                ADD HL, DE

                ; сохранение страницы для возврата после отображения
                PUSH_PAGE
                LD DE, SetPageInStack
                PUSH DE

                ; подготовка высоты кадра и отсутствующего горизонтального отсечения
                INC HL
                LD A, (HL)
                EXX
                LD B, A
                LD C, #00

                ; расчёт адреса верхнего левого знакоместа индикатора
                SCREEN_ADR_REG DE, SCR_ADR_BASE, \
                    Const.Suspend.PausePosX << 3, \
                    Const.Suspend.PausePosY << 3
                EXX

                ; чтение адреса данных выбранного кадра
                LD DE, FSprite.Data.Adr - FSprite.Info.Height
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)

                ; установка страницы данных и режима отображения с атрибутами
                LD A, (Kernel.Modules.World.Page)
                OR OR_XOR_ATTR
                LD (Kernel.Sprite.DrawClipping.Flags), A

                ; подготовка позиции и ширины кадра для существующего рисовальщика
                LD B, Const.Suspend.PausePosX << 3
                LD A, #01                                                       ; ширина в знакоместах минус один
                EX AF, AF'

                ; выбор таблицы размера для OR & XOR ATTR шириной два знакоместа
                LD H, HIGH Adr.MultiplySprite
                LD L, %10010001
                JP Kernel.Sprite.DrawOR_XOR_ATTR.ToCopy                         ; копирование кадра и отображение на основном экране
                
.Delay          ; задержки в IRQ в порядке таблицы спрайтов, затем задержка первого шага
                DB 14                                                           ; кадр 4
                DB 16                                                           ; кадр 3
                DB 2                                                            ; кадр 2
                DB 2                                                            ; кадр 1
                DB 2                                                            ; кадр 0
                DB 2                                                            ; первый шаг анимации
; -----------------------------------------
; восстановление рамки после остановки времени
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   необходимо включить страницу модуля "мира"
;   вызывается после выключения режима остановки времени
;   рамка восстанавливается на основном экране
;   знакоместо справа от верхней рамки восстанавливается до исходного фона
;   перенос на теневой экран запрашивается для штатной фазы копирования
; -----------------------------------------
.Resume         ; проверка необходимости восстановления рамки после остановки времени
                LD A, (.Frame)
                CP Const.Suspend.MaxFrame
                RET Z                                                           ; выход, если состояние анимации уже сброшено

                ; сброс состояния анимации для следующего включения
                LD A, Const.Suspend.MaxFrame
                LD (.Frame), A

                ; восстановление рамки на основном экране
                SET_RENDER_TO_BASE_SCREEN
                CALL GameplayFrame

                ; расчёт адреса знакоместа индикатора справа от верхней рамки
                SCREEN_ADR_REG HL, SCR_ADR_BASE, \
                    (Const.Suspend.PausePosX + 1) << 3, \
                    Const.Suspend.PausePosY << 3

                ; восстановление восьми строк исходного фона игрового окна
                LD B, #08
.ClearCell      LD (HL), #FF
                INC H
                DJNZ .ClearCell

                ; расчёт адреса атрибута восстановленного знакоместа
                SCREEN_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    Const.Suspend.PausePosX + 1, Const.Suspend.PausePosY

                ; восстановление исходного атрибута игрового окна
                SET_ATTR_IPB BLACK, WHITE, 0

                ; запрос переноса восстановленного участка рамки на теневой экран
                SET_FLAG_MODIFY World.SharedCode.Render.PipelineHexagons.SuspendFlag
                RET

                display " - Display gameplay suspend:\t\t\t\t\t\t= busy [ ", /D, $-GameplaySuspend, " byte(s) ]"

                endif ; ~_MODULE_WORLD_DISPLAY_GAMEPLAY_SUSPEND_
