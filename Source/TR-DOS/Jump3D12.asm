
                ifndef _TR_DOS_JUMP_3D13_
                define _TR_DOS_JUMP_3D13_
; -----------------------------------------
; переход в TR-DOS
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Jump3D13:       ; -----------------------------------------
                ; настройка перед запуском TR-DOS
                ; -----------------------------------------

                LD	(Shutdown.ContainerSP), SP
                PUSH HL

                ; установка адреса временного буфера
                LD HL, Buffer
                LD (Print.Buffer), HL

                ; указать адрес перехода при ошибке
                LD HL, CheckError
                EX (SP), HL
                LD (BASIC.ERR_SP), SP

                LD (Shutdown.ContainerIY), IY                                   ; сохранение IY
                PUSH AF                                                         ; сохранени аккумулятора
                
                ; настройка дефолтных переменных TR-DOS
                LD IY, BASIC.ERR_NR
                LD A, #FF
                LD (BASIC.ERR_NR), A                                            ; отсутствие ошибок BASIC
                LD (TRDOS.BUFF_FLAG), A                                         ; отключение выделения буфера ввода/вывода

                XOR A
                LD (TRDOS.TRDOS_ERR), A                                         ; сброс кода ошибки

                ; установка прерывания для ПЗУ
                DI
                LD A, #3F
                LD I, A
                IM 1

                POP AF

                CALL TRDOS.EXE_CMD                                              ; переход в TR-DOS

                ; -----------------------------------------
                ; завершение работы с TR-DOS
                ; -----------------------------------------
Shutdown:       DI

                ; проверка включения прерывания
                LD A, (Flags)
                BIT ENABLE_IM2_BIT, A
                JR Z, .RestoreRegs

                ; включение прерыания (по умолчанию)
                LD A, HIGH Adr.Interrupt-1
                LD I, A
                IM 2
                EI

.RestoreRegs    ; восстановление регистров
.ContainerIY    EQU $+2
                LD IY, #0000
.ContainerSP    EQU $+1
                LD SP, #0000

                RET

                endif ; ~ _TR_DOS_JUMP_3D13_
