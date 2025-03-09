                ifndef _DRAW_WORLD_BACKGROUND_
                define _DRAW_WORLD_BACKGROUND_
; -----------------------------------------
; отображение фон
; In:
; Out:
; Corrupt:
; Note:
;   установить RESTORE_BC
;   установить 7 страницу
;   устойчивый к прерываниям
; -----------------------------------------
Background:     ; -----------------------------------------
                ; расчёт адреса строки в экранной области
                ; -----------------------------------------
                SCREEN_ADR_REG DE, SCR_ADR_SHADOW, SCR_WORLD_POS_X << 3, SCR_WORLD_POS_Y << 3
                ADJUST_HIDDEN_SCR_ADR D                                         ; корректировка адреса скрытого экрана
                PUSH DE                                                         ; сохранение адреса экрана
                EXX                                                             ; спрятать адрес экрана

                ; -----------------------------------------
                ; инициализация
                ; -----------------------------------------
                LD IX, ColumnDraw
.Shift_Y        EQU $+1
                LD B, #00

                ; сохранение стека
                LD (ColumnDraw.ContainerSP), SP
                LD (Whole.ContainerSP), SP

                ; -----------------------------------------
                ; расчёт смещения спрайта по горизонтали
                ; -----------------------------------------

                ; проверка пропуска левой половинки тайла
.Shift_X        DB #B7                                                          ; SCF (#37), OR A (#B7)
                JR NC, .WholeRight                                              ; переход, если левая часть тайла отсутствует

.LeftWhole      ; -----------------------------------------
                ; отображается левая части и целой
                ; -----------------------------------------

                ; инициализация
                LD (Left.ContainerSP), SP                                       ; сохранение стека

                ; расчёт смещения спрайта по вертикали в байтах
                LD A, B
                ADD A, A    ; x2
                ADD A, B    ; x3
                ADD A, A    ; x6
                LD B, A     ; сохранение х6
                ADD A, A    ; x12
                ADD A, B    ; x18
                LD (Left.SprOffset), A
                LD (Whole.SprOffset), A

                ; расчёт адреса функций отрисовки
                LD A, B     ; восстановление х6
                ADD A, LOW .Table
                LD L, A
                ADC A, HIGH .Table
                SUB L
                LD H, A

                ; чтение адреса базовой функции отрисовки (левее от целой части)
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL
                LD (ColumnDraw.BasicDraw), HL                                   ; сохранение адреса базовой функции отрисовки

                ; модификация кода отрисовки, расставление JP (IX)
                DEC HL
                LD (HL), #E9
                DEC HL
                LD (HL), #DD
                LD (Restore.BasicDraw), HL                                      ; сохранение адреса порчи кода
                
                ; расчёт адреса завершающей функции отрисовки
                LD BC, Left.Diff+2
                ADD HL, BC
                PUSH HL
                POP IY

                ; чтение адреса базовой функции отрисовки (целой части)
                EX DE, HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL
                LD (Whole.BasicDraw), HL                                        ; сохранение адреса функции

                ; модификация кода отрисовки, расставление JP (IX)
                DEC HL
                LD (HL), #E9
                DEC HL
                LD (HL), #DD
                LD (Restore.FinalDraw), HL                                      ; сохранение адреса порчи кода

                ; расчёт адреса завершающей функции отрисовки
                LD BC, Whole.Diff+2
                ADD HL, BC
                LD (Whole.FinalDraw), HL                                        ; сохранение адреса завершающей функции отрисовки

                ; отображение
                LD DE, Adr.RenderBuffer
                LD BC, (SCR_WORLD_SIZE_Y << 8) | ((SCR_WORLD_SIZE_X * 2) - 1)
                JP Left

.WholeRight     ; -----------------------------------------
                ; отображается целой и правой части
                ; -----------------------------------------

                ; инициализация
                LD (Right.ContainerSP), SP                                      ; сохранение стека

                ; расчёт смещения спрайта по вертикали в байтах
                LD A, B
                ADD A, A    ; x2
                ADD A, B    ; x3
                ADD A, A    ; x6
                LD B, A     ; сохранение х6
                ADD A, A    ; x12
                ADD A, B    ; x18
                LD (Whole.SprOffset), A
                LD (Right.SprOffset), A

                ; расчёт адреса функций отрисовки
                LD A, B     ; восстановление х6
                ADD A, LOW (.Table+2)
                LD L, A
                ADC A, HIGH (.Table+2)
                SUB L
                LD H, A

                ; чтение адреса базовой функции отрисовки (целой части)
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL
                LD (ColumnDraw.BasicDraw), HL                                   ; сохранение адреса базовой функции отрисовки

                ; модификация кода отрисовки, расставление JP (IX)
                DEC HL
                LD (HL), #E9
                DEC HL
                LD (HL), #DD
                LD (Restore.BasicDraw), HL                                      ; сохранение адреса порчи кода
                
                ; расчёт адреса завершающей функции отрисовки
                LD BC, Whole.Diff+2
                ADD HL, BC
                PUSH HL
                POP IY

                ; чтение адреса базовой функции отрисовки (правее от целой части)
                EX DE, HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL
                LD (Right.BasicDraw), HL                                        ; сохранение адреса функции

                ; модификация кода отрисовки, расставление JP (IX)
                DEC HL
                LD (HL), #E9
                DEC HL
                LD (HL), #DD
                LD (Restore.FinalDraw), HL                                      ; сохранение адреса порчи кода

                ; расчёт адреса завершающей функции отрисовки
                LD BC, Right.Diff+2
                ADD HL, BC
                LD (Right.FinalDraw), HL                                        ; сохранение адреса завершающей функции отрисовки

                ; отображение
                LD DE, Adr.RenderBuffer
                LD BC, (SCR_WORLD_SIZE_Y << 8) | ((SCR_WORLD_SIZE_X * 2) - 2)
                JP Whole.Right

.Table          ; таблица функций отрисовки колонок
                DW Left.x00,  Whole.x00,  Right.x00
                DW Left.x08,  Whole.x08,  Right.x08
                
                display " - Draw background:\t\t\t\t\t", /A, Background, "\t= busy [ ", /D, $-Background, " byte(s)  ]"

                endif ; ~ _DRAW_WORLD_BACKGROUND_