
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
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
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
                ifdef ENABLE_MUSIC
                SET_PAGE_MUSIC                                                  ; включение страницы с музыкой
                CHECK_MUSIC_FLAG MUSIC_ENABLE_BIT
                CALL NZ, Sound.Tick
                endif
                ; ~ PLAY MUSIC

.RestoreMemPage ; ****** RESTORE MEMORY PAGE ******
                POP_PAGE                                                        ; восстановление номера страницы из стека
                ; ~ RESTORE MEMORY PAGE

                ;   описание проблемы гонки между чтением и записью общего состояния видимого экрана:
                ;   - до прерывания есть вероятность чтения состояния порта #7FFD из его копии в памяти
                ;   - если прерывание приходит до чтения состояния порта -> LD A, (BC), конфликта не будет,
                ;     так как после возврата из обработчика прерывания прочитаются актуальные данные
                ;     копии порта #7FFD
                ;   - если прерывание приходит после чтения состояния порта -> LD A, (BC),
                ;     но до OUT (C), A, может возникнуть гонка
                ;     в A прочитан текущий бит экрана, обработчик переключает экран и обновляет копию порта,
                ;     при выходе восстанавливает прежний A, основной код записывает из A прежний бит экрана,
                ;     что вызывает неправильное состояние видимого экрана
                ;
                ;   исправление:
                ;   - перед выходом из обработчика прерывания проверить адрес возврата
                ;   - если адрес находится в коде выше чтения порта -> LD A, (BC) или на самой инструкции
                ;     чтения, нормальное продолжение выполнения
                ;   - если адрес находится в коде ниже чтения порта -> LD A, (BC), но не дальше OUT (C), A,
                ;     заменим адрес возврата на повторное чтение
                ;   - если адрес находится после OUT (C), A, нормальное продолжение выполнения

                ; проверка адреса возврата до LD A, (BC) включительно
                LD HL, (.ReturnAddress)
                LD DE, SetPage.Pending
                OR A
                SBC HL, DE
                JR C, .RestoreReg                                               ; переход, если адрес возврата находится перед участком

                ; проверка адреса возврата после OUT (C), A
                LD DE, SetPage.Extended - SetPage.Pending
                SBC HL, DE
                JR NC, .RestoreReg                                              ; переход, если адрес возврата находится на конце участка или после него

                ; замена адреса возврата для повторного чтения копии порта
                LD HL, SetPage.ReadPort
                LD (.ReturnAddress), HL

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
