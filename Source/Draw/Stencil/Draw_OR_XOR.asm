
                ifndef _DRAW_STENCIL_DRAW_OR_XOR_
                define _DRAW_STENCIL_DRAW_OR_XOR_
Const:          ; константные значения
.StencilWidth   EQU #06                                                         ; ширина трафарета
.StencilHeight  EQU #07                                                         ; высота трафарета
.StencilPosX    EQU #19                                                         ; позиция трафарета по горизонтали в знакоместах
.StencilPosY    EQU #0D                                                         ; позиция трафарета по вертикали в знакоместах
.StencilBottom  EQU (Const.StencilPosY + Const.StencilHeight) << 3              ; нижняя граница трафарета
.StencilRight   EQU (Const.StencilPosX + Const.StencilWidth) << 3               ; правая граница трафарета

; -----------------------------------------
; отображение спрайта OR & XOR через трафарет
; In:
;   HL - адрес данных спрайта OR & XOR
;   DE - координаты в пикселях (D - y, E - x)
;   BC - размер спрайта в пикселях (B - y, C - x)
;   IX - адрес начала трафарета 48x56
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY, SP
; Note:
;   вывод выполняется только в базовый экран #4000
; -----------------------------------------
DrawOR_XOR:     ; проверка положения спрайта относительно нижней границы трафарета
                LD A, D                                                         ; хранит позицию спрайта по вертикали в пикселях
                CP Const.StencilBottom
                RET NC                                                          ; выход, если спрайт начинается под трафаретом

                ; проверка положения левой границы спрайта относительно левой границы трафарета
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                CP Const.StencilPosX << 3
                JR NC, .CheckRight                                              ; переход, если левое отсечение отсутствует

                ; проверка положения правой границы спрайта относительно левой границы трафарета
                ADD A, C                                                        ; правая граница спрайта
                CP (Const.StencilPosX << 3) + 1
                RET C                                                           ; выход, если спрайт полностью находится слева от трафарета

.CheckRight     ; -----------------------------------------

                ; проверка положения спрайта относительно правой границы трафарета
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                CP Const.StencilRight
                RET NC                                                          ; выход, если спрайт начинается справа от трафарета

                ; корректировка высоты видомого спрайта
                LD A, Const.StencilBottom
                SUB D
                CP B
                JR NC, $+3
                LD B, A                                                         ; новая высота спрайта

                ; -----------------------------------------

                ; сохранение адреса данных спрайта
                LD (.SpriteAddress), HL

                ; -----------------------------------------

                ; определение смешения
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                AND %00000111
                ADD A, #FF                                                      ; выставить флаг переполнения, если есть смещение

                ; -----------------------------------------
                ;      7    6    5    4    3    2    1    0
                ;   +----+----+----+----+----+----+----+----+
                ;   | -  | -  | -  | -  | -  | S  |  W |  0 |
                ;   +----+----+----+----+----+----+----+----+
                ;
                ;   S       [2]         - флаг, вывода со смещением
                ;   W       [1]         - ширина спрайта
                ;                           0 - 48 пикселей
                ;                           1 - 32 пикселя
                ; -----------------------------------------
                ADC A, A    ; сохранение флага переполнения (вывода со смещением)
                LD L, A
                LD A, C
                CP #30
                LD A, L
                ADC A, A    ; сохранение флага переполнения (ширина спрайта)
                ADD A, A    ; x2
                AND %00000111
                
                ; расчёт адреса смещения в таблице
                LD HL, .Table
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                ; чтение адреса таблицы переходов
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A
 
                LD IYH, #00                                                     ; очистка количества отсекаемых знакомест
                LD IYL, C                                                       ; сохранение ширины спрайта

                ; проверка необходимости левого отсечения
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                CP Const.StencilPosX << 3
                JR C, .LeftClip                                                 ; переход, если требуется левое отсечение

                ; расчёт отсечения правой границей трафарета
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                SUB Const.StencilRight
                ADD A, C                                                        ; количество пикселей за правой границей трафарета
                LD C, #00
                JR NC, .HorizontClipped                                         ; переход, если спрайт не достигает правой границы
                JR Z, .HorizontClipped                                          ; переход, если спрайт заканчивается ровно на границе

                ; округление количества отсекаемых пикселей до знакоместа
                ADD A, #07
                SRL A
                SRL A
                SRL A
                LD C, A                                                         ; знаковое количество отсекаемых знакомест
                LD IYH, A                                                       ; количество отсекаемых знакомест
                JR .HorizontClipped

.LeftClip       ; расчёт количества знакомест перед левой границей трафарета
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                RRCA
                RRCA
                RRCA
                AND %00011111                                                   ; позиция спрайта по горизонтали в знакоместах
                SUB Const.StencilPosX                                           ; знаковое количество отсекаемых знакомест
                LD C, A

                ; расчёт абсолютного количества отсекаемых знакомест
                NEG
                LD IYH, A                                                       ; количество отсекаемых знакомест

.HorizontClipped; -----------------------------------------

                ; расчёт ширины спрайта с учётом смещения
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                AND %00000111                                                   ; пиксельный сдвиг
                ADD A, IYL                                                      ; ширина со сдвигом
                ADD A, #07
                SRL A
                SRL A
                SRL A

                ; расчёт корректировки шага, перехода на новую строку
                NEG
                ADD A, Const.StencilWidth                                       ; ширина трафарета

                ; расчёт шага трафарета с учётом пропущенных байтов спрайта
                ADD A, IYH
                LD (Function.OR_XOR.NextRow.StencilStep), A                     ; младший байт шага трафарета
                ADD A, A
                SBC A, A
                LD (Function.OR_XOR.NextRow.StencilStep + 1), A                 ; старший байт шага трафарета

                ; -----------------------------------------

                ; расчёт смещения относительно адреса функций вывода
                LD A, C                                                         ; хранит знаковое количество отсекаемых знакомест
                ADD A, A    ; x2
                ADD A, C    ; x3
                ADD A, A    ; x6

                ; применение смещения относительно начального адреса функций вывода
                ADD A, L
                LD L, A
                ADC A, H
                SUB L

                ; коррекция старшего байта для отрицательного смещения
                SLA C                                                           ; перенос знакового бита смещения
                SBC A, #00
                LD H, A

.ReadFunction   ; чтение адреса функции отображения последующей строки
                LD A, (HL)
                LD IYL, A
                INC HL
                LD A, (HL)
                LD IYH, A
                INC HL

                ; чтение адреса функции отображения первой строки
                LD A, (HL)
                LD (.DrawFunction), A
                INC HL
                LD A, (HL)
                LD (.DrawFunction + 1), A
                INC HL

                ; чтение адреса продолжения вывода строки
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A

.UpdateFunctions; обновление адресов продолжения вывода строки
                LD (Function.OR_XOR.NoShift_OX.ContinueDraw), HL
                LD (Function.OR_XOR.Shift_OX_Left.ContinueDraw), HL
                LD (Function.OR_XOR.Shift_OX_Right.ContinueDraw), HL

                ; -----------------------------------------

                ; проверка наличия пиксельного сдвига
                LD A, E
                AND %00000111
                JR Z, .NoShift                                                  ; переход, если пиксельный сдвиг отсутствует

                ; расчёт старшего байта адреса таблицы сдвига
                ADD A, A                                                        ; x2
                ADD A, (HIGH Adr.ShiftTable) - 2
                LD (.ShiftTable), A
                LD (Function.OR_XOR.NextRow.ShiftTable), A

.NoShift        ; проверка положения вывода относительно левой границы трафарета
                LD A, E                                                         ; хранит позицию спрайта по горизонтали в пикселях
                CP Const.StencilPosX << 3
                JR NC, .Selected                                                ; переход, если левое отсечение отсутствует
                LD E, Const.StencilPosX << 3                                    ; позиция левой границы трафарета

.Selected       ; подготовка адресов трафарета и экрана

                ; сохранение высоты спрайта
                LD A, B
                EX AF, AF'

                ; расчёт смещения строки спрайта относительно трафарета
                ; offsetY = (Y - StencilPosY) * 6
                LD A, D                                                         ; хранит позицию спрайта по вертикали в пикселях
                SUB Const.StencilPosY << 3
                LD L, A
                ADD A, A
                SBC A, A
                LD H, A
                LD B, H
                LD C, L
                ADD HL, HL  ; x2
                ADD HL, BC  ; x3
                ADD HL, HL  ; x6

                ; расчёт смещения знакоместа относительно трафарета
                ; offsetX = ((X / 8) - StencilPosX)
                LD A, E
                RRCA
                RRCA
                RRCA
                AND %00011111
                SUB Const.StencilPosX                                           ; X / 8 - 25
                LD C, A
                ADD A, A
                SBC A, A
                LD B, A

                ; применение рассчитанного смещения к адресу трафарета
                ; offset = IX + ((Y - StencilPosY) * 6) + ((X / 8) - StencilPosX)
                ADD HL, BC
                LD B, H
                LD C, L
                ADD IX, BC

                ; -----------------------------------------

                ; расчёт адреса базового экрана по координатам
                LD H, HIGH Adr.ScrAdrTable
                LD L, D
                LD A, (HL)
                INC H
                LD D, (HL)
                RES 7, D                                                        ; переход на базовый экран
                INC H
                LD L, E
                OR (HL)
                LD E, A

                ; подготовка адреса начала строки и счётчиков
                LD L, E
                LD A, #F8
                AND D
                LD H, A
                SUB D
                ADD A, #08
                LD B, A                                                         ; количество строк в знакоместе
                EX AF, AF'                                                      ; восстановление высоты спрайта
                LD C, A                                                         ; количество строк рисования

                PUSH DE                                                         ; переброска адрес экрана
                EXX
                POP DE

                ; защитная от порчи данных с разрешённым прерыванием
                RESTORE_BC
                LD (Function.OR_XOR.NextRow.ContainerSP), SP

.SpriteAddress  EQU $+1
                LD HL, #0000
                LD C, (HL)
                INC HL
                LD B, (HL)
                INC HL
                LD SP, HL

.ShiftTable     EQU $+1
                LD H, #00                                                       ; HIGH Adr.ShiftTable

.DrawFunction   EQU $+1
                JP #0000

.Table          ; таблица функций без сдвига
                DW Function.OR_XOR.NoShift.Table.OX_48, Function.OR_XOR.NoShift.Table.OX_32
                ; таблица функций со сдвигом 
                DW Function.OR_XOR.Shift.Table.OX_48,   Function.OR_XOR.Shift.Table.OX_32

                display " - Draw stencil function 'OR XOR':\t\t\t\t\t= busy [ ", /D, $-DrawOR_XOR, " byte(s) ]"

                endif ; ~ _DRAW_STENCIL_DRAW_OR_XOR_
