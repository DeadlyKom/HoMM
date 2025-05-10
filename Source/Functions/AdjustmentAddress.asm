; -----------------------------------------
; корректирование адресов
; In:
;   HL - адрес запуска
; Out:
; Corrupt:
; Note:
;   корректирует адреса перемещаемого кода,
;   после изменяет его для вызова используя таблицу переходов
; -----------------------------------------
AdjustmentAdr:  PUSH HL                                                         ; сохранение адреса вызова

                ; расчёт адреса таблицы релокации
                LD BC, .RelocateTable
                ADD HL, BC

                ; проверка необходимости корректировки адресов
                LD A, (HL)                                                      ; количество корректируемых адресов
                INC L

                ; расчёт адреса расположения кода
                LD E, A
                LD D, #00
                EX DE, HL
                ADD HL, HL  ; x2
                ADD HL, DE
                PUSH HL

                ; проверка наличия корректируемых адресов
                OR A
                JR Z, .Finish                                                   ; переход, если отсутствует корректируемы адреса

                ; адрес расположения таблици релокации
                LD H, D
                LD L, E

.Loop           ; чтение смещения
                EX DE, HL
                LD C, (HL)
                INC L
                LD B, (HL)
                INC L
                EX DE, HL
                ADD HL, BC

                ; создание на стеке копии адреса расположения кода
                POP BC
                PUSH BC
                PUSH BC

                ; чтение смещения от текущего адреса
                LD C, (HL)
                INC HL
                LD B, (HL)

                ; приращение к адресу расположения кода смещение из таблицы релокации
                EX (SP), HL                                                     ; HL = копия адреса расположения кода
                ADD HL, BC
                EX (SP), HL                                                     ; HL = указывает на корректируемый адрес
                POP BC                                                          ; результат приращения

                ; корректировка адреса
                LD (HL), B
                DEC HL
                LD (HL), C

                DEC A
                JR NZ, .Loop

.Finish         ; модификация кода
                POP DE                                                          ; адреса расположения кода
                POP HL                                                          ; восстановление адреса вызова

                ;   LD HL, JumpTable
                ;   POP AF
                ;   JP Func.JumpTable

                LD (HL), #21                                                    ; LD HL, nnnn
                INC L
                LD (HL), E
                INC L
                LD (HL), D
                INC L 
                LD (HL), #F1                                                    ; POP AF
                INC L
                LD (HL), #C3                                                    ; JP nnnn
                INC L
                LD (HL), LOW Func.JumpTable
                INC L
                LD (HL), HIGH Func.JumpTable
                
                ; первичная инициализация
                XOR A
                PUSH AF
                JR AdjustmentAdr

.RelocateTable  EQU $
