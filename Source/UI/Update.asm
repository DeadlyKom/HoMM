
                ifndef _UI_UPDATE_
                define _UI_UPDATE_
; -----------------------------------------
; обновление UI
; In:
;   HL - указывает на массив FUILayer
;   B  - количество слоёв в массиве
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Update:         ; сброс флага, найденого перекрытия
                LD A, #B7                                                       ; OR A/SCF #B7/#37
                LD (.Flag), A

.LayerLoop      ; основной цикл обхода слои
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
                INC HL
                LD H, (HL)
                LD L, A

.UILoop         ; цикл обхода элементов UI
                BIT UI_VISIBLE_BIT, (HL)
                JR Z, .NextUI
                BIT UI_ENABLED_BIT, (HL)
                JR Z, .NextUI

                PUSH HL
                PUSH BC
                INC HL

                ; чтение адреса обработчика
                LD A, (HL)
                LD IXL, A
                INC HL
                LD A, (HL)
                LD IXH, A
                INC HL

                ; чтение положение элемента на экране
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL

                ; чтение размера элемента
                LD B, (HL)
                INC HL
                LD C, (HL)

                CALL HandlerIfInRect

                POP BC
                POP HL

.NextUI         LD DE, FUIElement
                ADD HL, DE
                DJNZ .UILoop

                POP BC
                POP HL

.NextLayer      LD DE, FUILayer
                ADD HL, DE
                DJNZ .LayerLoop

                ; флаг найденого перекрытия
.Flag           EQU $
                NOP
                RET NC                                                          ; выход, если перекрытие не найдены

                ; уменьшить таймер
                LD HL, TooltipTimer
                DEC (HL)
                RET NZ                                                          ; выход, если таймер не нулевой
                
                ; обновим счётчик таймера
                LD (HL), UI_TOOLTIP_HOVER_DELAY

                ; вызов обработчика
                OR A                                                            ; сброс флага, для обработчика, сигнализирующий обнуление таймера подсказки
                JP (IX)

ResetTimer      LD HL, TooltipTimer
                LD (HL), UI_TOOLTIP_HOVER_DELAY
                RET

                ; DE - позиция элемента (D - y, E - x)
                ; BC - размер элемента (B - y, C - x)
HandlerIfInRect:; инициализация
                LD HL, Mouse.Position                                           ; ось X
                
                ; проверка по горизонтали
                LD A, (HL)
                CP E
                RET C                                                           ; выход, если курсор находится левее прямоугольнка
 
                LD A, E
                ADD A, C
                CP (HL)
                RET C                                                           ; выход, если курсор находится правее прямоугольника
                
                INC HL                                                          ; ось Y
                ; проверка по вертикали
                LD A, (HL)
                CP D
                RET C                                                           ; выход, если курсор находится выше прямоугольнка
 
                LD A, D
                ADD A, B
                CP (HL)
                RET C                                                           ; выход, если курсор находится ниже прямоугольника

                ; установка флага найденого перекрытия
                LD A, #37                                                       ; OR A/SCF #B7/#37
                LD (Update.Flag), A

                ; 
.Prev           EQU $+1
                LD BC, #0000
                LD (.Prev), IX
                PUSH IX
                POP HL
                SBC HL, BC
                CALL NZ, ResetTimer

                ; курсор находится в прямоугольнике
                SCF                                                             ; установка флага, для обработчика, сигнализирующий вызов по перекрытию
                JP (IX)                                                         ; переход в обработчик, если в области элемента

                display " - Update UI elements:\t\t\t\t\t\t", /A, Update, "\t= busy [ ", /D, $-Update, " byte(s)  ]"

                endif ; ~_UI_UPDATE_
