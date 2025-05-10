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
AdjustmentAdr:  PUSH HL

                LD IX, #0000
                ADD IX, SP

                PUSH HL
                ; определение текущего адреса
                LD BC, RelocateTable
                ADD HL, BC
                POP BC
                LD SP, HL

                EXX
                LD BC, relocate_count
                
.Loop           EXX
                POP HL
                ADD HL, BC

                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL
                ADD HL, BC
                EX DE, HL
                LD (HL), D
                DEC HL
                LD (HL), E

                EXX
                DEC BC
                LD A, B
                OR C
                JR NZ, .Loop

                LD SP, IX

                POP DE
                LD HL, .JumpTable
                ADD HL, DE
                EX DE, HL

                LD (HL), #21
                INC L
                LD (HL), E
                INC L
                LD (HL), D
                INC L

                ; модификация кода
                ;   POP AF
                ;   JP Func.JumpTable
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

.JumpTable      EQU $
