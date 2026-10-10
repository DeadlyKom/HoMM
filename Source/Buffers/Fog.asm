
                ifndef _BUFFERS_FOG_
                define _BUFFERS_FOG_

                module Fog

Const:          ; константные значения
.MaxAnimations  EQU #0A                                                         ; максимальное количество одновременно активных анимаций
.InitialTicks   EQU #03                                                         ; начальное значение счётчиков периодов анимации

; -----------------------------------------
; запуск анимации невидимого гексагона
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; Note:
;   ℹ️ код расположен в странице 1
; -----------------------------------------
Make:           ; проверка периода запуска анимации
                LD HL, MakeCounter
                DEC (HL)
                RET NZ                                                          ; выход, если период анимации ещё не завершён

                ; расчёт задержки до следующего запуска анимации
                LD A, R
                AND %00000111
                ADD A, #0A
                LD (HL), A

                ; проверка наличия свободных мест в буфере анимаций
                LD A, (BufferNum)
                OR A
                RET Z                                                           ; выход, если свободные места в буфере отсутствуют
                EX AF, AF'

                EXX
                ; A = rand() % 40
                CALL Math.Rand8
                ; -----------------------------------------
                ; деление D на E
                ; In:
                ;   D - делимое
                ;   E - делитель
                ; Out:
                ;   D - результат деления (D / E)
                ;   A - остаток (D % E)
                ; Corrupt:
                ;   D, AF
                ; -----------------------------------------
                LD D, A
                LD E, 40-5
                CALL Math.Div8x8                                                ; mod
                EXX
                ; LD A, 0
                LD E, A

                LD D, HIGH Adr.RenderBuffer
                ; проверка разведанности выбранного гексагона
                LD A, (DE)
                BIT MAP_META_FOG_PLAYER_1_BIT, A
                RET NZ                                                          ; выход, если гексагон уже разведан

                LD BC, Const.MaxAnimations
                LD HL, Buffer

                ; поиск одинакового индекса
.IdxLoop        CPI
                RET Z                                                           ; выход, если найдено совпадение в буфере
                JP PE, .IdxLoop                                                 ; переход, если просмотрены не все элементы буфера

                ; поиск свободного индекса
                EX AF, AF'
                LD C, A
                LD A, #FF
                DEC HL

.FreeLoop       CPD
                JR Z, .Make                                                     ; переход, если найден свободный элемент буфера
                JP PE, .FreeLoop                                                ; переход, если просмотрены не все элементы буфера
                RET

.Make           ; сохранение индекса гексагона
                INC HL
                ; LD D, HIGH Adr.RenderBuffer
                ; -----------------------------------------
                ; обновление вокруг указанного гексагона
                ; In:
                ;   DE - адрес обновляемого гексогонального тайла
                ; Out:
                ; Corrupt:
                ;   AF, HL', D', BC', AF', IX
                ; Note:
                ;   ℹ️ код расположен в странице 1
                ; -----------------------------------------
                CALL BufferUtilities.UpdateHextile
                RET C                                                           ; выход, если обновление гексагона отклонено

                LD (HL), E

                LD A, %10001111
                LD (DE), A

                LD A, (BufferNum)
                DEC A
                LD (BufferNum), A
                RET
; -----------------------------------------
; обновление анимаций невидимых гексагонов
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; Note:
;   ℹ️ код расположен в странице 1
; -----------------------------------------
Tick:           ; проверка периода обновления анимаций
                LD HL, TickCounter
                DEC (HL)
                RET NZ                                                          ; выход, если период анимации ещё не завершён
                LD (HL), #04

                ; расчёт количества активных анимаций
                LD A, (BufferNum)
                LD B, A
                LD A, Const.MaxAnimations
                SUB B
                ; проверка наличия активных анимаций
                RET Z                                                           ; выход, если анимации в буфере отсутствуют

                LD B, A
                LD HL, Buffer-1
                LD D, HIGH Adr.RenderBuffer

.Loop           ; проверка занятости элемента буфера анимаций
                INC HL
                LD A, (HL)
                CP #FF
                JR Z, .Loop                                                     ; переход, если элемент буфера свободен

                LD E, A

                ; расчёт следующей фазы анимации гексагона
                LD A, (DE)
                AND %00000111
                DEC A
                ; проверка завершения анимации гексагона
                JP P, .SetFog                                                   ; переход, если анимация гексагона ещё не завершена

                LD (HL), #FF
                LD A, (BufferNum)
                INC A
                LD (BufferNum), A

                LD A, %10000000
                JR .Set

.SetFog         OR %10001000
.Set            LD (DE), A
                ; -----------------------------------------
                ; обновление вокруг указанного гексагона
                ; In:
                ;   A - индекс в рендер буфере (0-39)
                ; Out:
                ; Corrupt:
                ;   AF, HL', D', BC', AF', IX
                ; Note:
                ;   ℹ️ код расположен в странице 1
                ; -----------------------------------------
                CALL BufferUtilities.UpdateHextile
                DJNZ .Loop
                RET
; -----------------------------------------
; сброс буфера анимаций невидимых гексагонов
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в странице 1
; -----------------------------------------
Reset:          LD HL, Buffer
                LD A, Const.MaxAnimations
                LD (BufferNum), A
                LD B, A
.Loop           LD (HL), #FF
                INC HL
                DJNZ .Loop

                ; инициализация счётчиков периодов анимации
                LD A, Const.InitialTicks
                LD (MakeCounter), A
                LD (TickCounter), A
                RET

Buffer          EQU Adr.FogBuffer
BufferNum       EQU Buffer + Const.MaxAnimations
MakeCounter     EQU BufferNum + 1
TickCounter     EQU MakeCounter + 1

                endmodule

                endif ; ~_BUFFERS_FOG_
