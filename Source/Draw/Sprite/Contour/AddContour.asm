                ifndef _DRAW_SPRITE_CONTOUR_ADD_CONTOUR_
                define _DRAW_SPRITE_CONTOUR_ADD_CONTOUR_
; -----------------------------------------
; добавление контура к спрайту
; In:
;   HL  - адрес спрайта
;   B'  - размер спрайта по вертикали в пикселях
;   A'  - размер спрайта по горизонтали в знакоместах минус один
;   GameState.View - номер фазы обводки
; Out:
; Corrupt:
; Note:
; -----------------------------------------
AddContour:     ; сохранение основных регистров
                PUSH AF
                PUSH DE
                PUSH BC
                PUSH IX
                PUSH IY
                PUSH HL                                                         ; сохранение адреса спрайта
          
                ; чтение номера фазы
                LD A, (GameState.View)
                AND CONTOUR_PHASE_MASK
                LD (Vertical.Inner), A                                          ; радиус внутреннего расширения

                ; выбор обработчика контура и подготовки внутреннего окна
                OR A
                LD HL, ApplySimple                                              ; добавление внешнего расширения
                LD DE, Vertical.Columns                                         ; пропуск внутреннего окна
                JR Z, .Mode                                                     ; переход, если выбрана фаза 0 без внутреннего окна

                LD HL, ApplyRing                                                ; добавление разности внешней и внутренней масок
                LD DE, Vertical.InnerWindow                                     ; подготовка обоих вертикальных окон
.Mode           LD (Vertical.Apply), HL
                LD (Vertical.Window), DE

                ; расчёт внешнего радиуса, на один пиксель больше внутреннего
                INC A
                LD (Vertical.Outer), A

                ; расчёт первой строки повторного использования полных окон
                INC A
                LD (Vertical.MiddleStart), A

                ; чтение размера спрайта по горизонтали из A'
                EX AF, AF'
                LD C, A
                EX AF, AF'
                INC C
                LD A, C
                LD (.Width), A

                ; сохранение альтернативного аккумулятора и флагов
                EX AF, AF'
                PUSH AF
                EX AF, AF'

                ; чтение размера спрайта по вертикали из B' и сохранение альтернативных регистров
                EXX
                LD A, B
                PUSH HL
                PUSH DE
                PUSH BC
                EXX

                ; подготовка размера спрайта по вертикали для обоих проходов
                LD IXH, A                                                       ; размер спрайта по вертикали
                LD IXL, A                                                       ; счётчик строк горизонтального прохода

                ; расчёт первой строки нижней границы спрайта
                LD A, (Vertical.Outer)
                NEG
                ADD A, IXL
                LD (Vertical.MiddleEnd), A

                ; расчёт смещения по фазе контура и размеру спрайта по горизонтали
                DEC C
                LD A, (Vertical.Inner)
                ADD A, A    ; x2
                ADD A, A    ; x4
                OR C
                ADD A, A    ; x2

                ; добавить смещение к таблице
                LD C, A
                LD B, #00
                LD HL, Horizontal.Table
                ADD HL, BC

                ; чтение адреса обработчика строки
                LD C, (HL)
                INC HL
                LD B, (HL)
                LD (.Horizontal), BC

                ; проверка выбора таблиц для фазы 2
                LD A, (Vertical.Inner)
                CP #02

                ; подготовка адресов таблиц горизонтального расширения
.Table          EQU $+1
                LD A, #00                                                       ; часть 0 таблицы радиуса 1
.Outer          EQU $+1
                LD H, #00                                                       ; часть 0 таблицы радиуса 2
                JR NZ, .Buffers                                                 ; переход, если выбрана фаза 0 или 1

                ADD A, #03                                                      ; часть 0 таблицы радиуса 2
                INC H                                                           ; переход к части таблицы +1 радиуса 2
                INC H                                                           ; переход к части таблицы -1 радиуса 2
                INC H                                                           ; переход к части таблицы 0 радиуса 3

                ; подготовка адреса внешней маски и переключение регистров
.BufferO        EQU $+2
.Buffers        LD DE, #0080
                EXX
                LD D, A                                                         ; часть 0 основной маски

                ; подготовка адреса спрайта для записи контура
                POP HL
                PUSH HL

.BufferH        EQU $+3
                LD IY, #0040
.Horizontal     EQU $+1
.Call           CALL #0000                                                      ; горизонтальное расширение маски спрайта
                POP HL
                PUSH HL

                ; подготовка номера строки и размера спрайта по вертикали
                LD A, IXH
                LD IXL, A
                LD IXH, #00

                ; подготовка размера спрайта по горизонтали и шага строк маски
.Width          EQU $+1
                LD A, #00
                LD IYH, A
                EXX
                LD E, A
                LD D, #00
                EXX

                ; подготовка адреса внутренней маски
.BufferV        EQU $+1
                LD DE, #0000
                CALL Vertical                                                   ; вертикальное расширение и добавление контура к спрайту

                ; восстановление регистров
                EXX
                POP BC
                POP DE
                POP HL
                EXX
                EX AF, AF'
                POP AF
                EX AF, AF'

                POP HL
                POP IY
                POP IX
                POP BC
                POP DE
                POP AF
                RET

                endif ; ~ _DRAW_SPRITE_CONTOUR_ADD_CONTOUR_
