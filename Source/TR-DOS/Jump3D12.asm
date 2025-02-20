
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

                ; указать адрес перехода при ошибке
                PUSH HL
                LD HL, (BASIC.ERR_SP)
                LD (Shutdown.ERR_SP), HL
                LD HL, Shutdown.ErrorHandler
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

.ErrorHandler   ; обработчик ошибки
.ERR_SP         EQU $+1
                LD HL, #0000
                LD (BASIC.ERR_SP), HL

                ; проверка на ошибку
                LD A, (TRDOS.TRDOS_ERR)
                OR A                                                            ; операция закончилась усмпешно
                RET Z
                
                SCF                                                             ; операция закончилась с ошибкой
                RET

                endif ; ~ _TR_DOS_JUMP_3D13_
