
                ifndef _INTERRUPT_HANDLER_
                define _INTERRUPT_HANDLER_
; -----------------------------------------
; обработчик прерывания
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Handler:        ; ********** HANDLER IM 2 *********
                EX (SP), HL
                LD (.ReturnAddress), HL
                POP HL                                                          ; восстановить значение HL
                LD (.Container_SP), SP                                          ; сохранить исходный указатель стека
.RestoreRegister EQU $
                NOP                                                             ; восстановить поврежденные байты ниже SP (PUSH HL/DE/BC)
                LD SP, Int.StackTop                                             ; использовать стек прерывания

.SaveRegs       ; ********* SAVE REGISTERS ********
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH IX
                PUSH IY
                PUSH AF
                EX AF, AF'
                PUSH AF
                EXX
                PUSH HL
                PUSH DE
                PUSH BC
                ; ~ SAVE REGISTERS

.SaveMemPage    ; ******** SAVE MEMORY PAGE *******
                ; PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                ; ~ SAVE MEMORY PAGE

.TickCounter    ; ********** TICK COUNTER *********
.TickCounterPtr EQU $+1
                LD HL, #0000
                INC HL
                LD (.TickCounterPtr), HL

                ; ********* USER INTERRUPT ********

.UserInterrupt  EQU $+1
                CALL .RET
                ; ~ USER INTERRUPT

.Music          ; *********** PLAY MUSIC **********
                ; play music
                ; ifdef ENABLE_MUSIC
                ; SET_PAGE_MUSIC                                                  ; включение страницы с музыкой
                ; CHECK_MUSIC_FLAG MUSIC_ENABLE_BIT
                ; CALL NZ, Music.Tick
                ; endif
                ; ~ PLAY MUSIC

.RestoreMemPage ; ****** RESTORE MEMORY PAGE ******
                ; POP_PAGE                                                        ; восстановление номера страницы из стека
                ; ~ RESTORE MEMORY PAGE

.RestoreReg     ; ******** RESTORE REGISTERS ******
                POP BC
                POP DE
                POP HL
                EXX
                POP AF
                EX AF, AF'
                POP AF
                POP IY
                POP IX
                POP BC
                POP DE
                POP HL
                ; ~ RESTORE REGISTERS

.Container_SP   EQU $+1
                LD SP, #0000
                EI
.ReturnAddress  EQU $+1
                JP #0000
                ; ~ HANDLER IM 2
.RET            RET

                endif ; ~ _INTERRUPT_HANDLER_
