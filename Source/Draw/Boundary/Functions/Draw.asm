
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_DRAW_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_DRAW_
; -----------------------------------------
; отображение спрайта с атрибутами
; In:
;   SP+0 - указывает на адрес спрайта
;   DE   - координаты (D - y, E - x)        (в пикселях)
;   C    - флаги вывода спрайта
;   IX   - адрес функции рисования
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; инициализация
                LD IY, .Continue
                LD A, (VHCounters+1)
                EX AF, AF'

                ; установка направления отображения по горизонтали
                LD A, #34                                                       ; INC (HL)
                BIT SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL_BIT, C
                JR Z, $+3
                INC A                                                           ; DEC (HL)
                LD (.Direction), A
                
                ; рассчёт адреса экранной области
                LD H, HIGH Adr.ScrAdrTable
                LD L, D                                                         ; номер строки по вертикали в пикселях
                LD A, (HL)
                INC H
                LD D, (HL)
                RES 7, D                                                        ; сброс бита, переход на основной экран
                INC H
                LD L, E
                OR (HL)
                LD E, A
                LD (.ScreenAdr), DE
                
                ;
                POP HL                                                          ; взятие адреса спрайта
                LD (.ContainerSP), SP
                
                ; чтение двух байт спрайта
                LD C, (HL)
                INC HL
                LD B, (HL)
                INC HL
                LD SP, HL

.HorizontalLoop ; цикл по горизонтали
.ScreenAdr      EQU $+1
                LD DE, #0000

.VerticalLoop   ; цикл по вертикали

                ;   SP - адрес спрайта
                ;   HL - адрес экрана
                ;   BC - два байта спрайта
                JP (IX)

.Continue       ; проверка ограничения по вертикали
                EX AF, AF'
                DEC A
                JR Z, .SkipBoundary                                             ; переход, если ограничение по вертикали достигнуто
                EX AF, AF'

                ; проверка завершения цикла по вертикали
                SRA A                                                           ; флаг, отвечающий за рисование продолжение рисования по вертикали
                                                                                ;   если сброшен, переход к следующему знакоместу по горизонтали
                                                                                ;   если установлен, продолжаем вывод по вертикали
                JR C, .VerticalLoop                                             ; переход, если продолжаем вывод по вертикали

.NextHorz       ; проверка ограничения по горизонтали
                LD HL, VHCounters
                DEC (HL)
                JR Z, .Exit                                                     ; переход, если ограничение по горизонтали достигнуто

                ; обновление счётчика ограничения по вертикали
                EX AF, AF'
                INC HL
                LD A, (HL)
                EX AF, AF'

                ; переход к следующему знакоместу по горизонтали
                LD HL, .ScreenAdr
.Direction      EQU $
                NOP                                                             ; #34/#35 - INC (HL)/DEC (HL)

                ; проверка цикла по горизонтали
                SRA A                                                           ; флаг, отвечающий за завершение рисования
                                                                                ;   если сброшен, цикл не завершён
                                                                                ;   если установлен, данные спрайта исчерпаны
                JR NC, .HorizontalLoop                                          ; переход, если цикл по горизонтали не завершён

.Exit           ; выход
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

.SkipBoundary   ; BC хранит 2 байта спрайта (текущего знакоместа)
                POP BC      ; x4
                POP BC      ; x6
                POP BC      ; x8
                POP BC      ; пропус атрибутов знакоместа
                LD A, B
                POP BC      ; чтение двух байт спрайта

                ; проверка завершения цикла по вертикали
                SRA A                                                           ; флаг, отвечающий за рисование продолжение рисования по вертикали
                                                                                ;   если сброшен, переход к следующему знакоместу по горизонтали
                                                                                ;   если установлен, продолжаем вывод по вертикали
                JR NC, .SkipBoundary                                            ; переход, если продолжаем вывод по вертикали
                JR .NextHorz                                                    ; продолжение обработки цикла по горизонтали

                display " - Draw sprite aligned in boundary 'Draw':\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_DRAW_
