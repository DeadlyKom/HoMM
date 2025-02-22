
                ifndef _TR_DOS_INITIALIZE_
                define _TR_DOS_INITIALIZE_
; -----------------------------------------
; инициализация работы с TR-DOS
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     ; сохранеие позиция головки дисковода
                LD HL, (TRDOS.CUR_SEC)
                PUSH HL

                ; установка адреса обработки ошибок работы TR-DOS
                LD A, #C3                                                       ; JP
                LD (TRDOS.WITH_RET + 0), A
                LD HL, ErrorHandler                                             ; адрес обработчика ошибок
                LD (TRDOS.WITH_RET + 1), HL
                
                ; сброс переменных перед инициализацией
                XOR A

                ; сброс дисководов
                LD HL, TRDOS.DRIVE_A
                LD (HL), A                                                      ; дисковод "А"

                ; сброс времени перемещения головки дисковода
                LD HL, TRDOS.RATE_A
                DEC A
                LD (HL), A                                                      ; дисковод "А"

                LD A, TRDOS.NUM_DRIVE_A
                
.InitDrive      ; сохранение номера инициализируемо привода
                LD (.Drive), A

                ; выполняется команда "Восстановление" ВГ93: головка отводится на нулевую 
                ; дорожку и ожидает сигнала INTRQ. Ожидание можно прервать нажатием клавиши BREAK
                LD C, TRDOS.RESTORE_VG93
                CALL Jump3D13                                                   ; переход в TR-DOS
                JR C, .Exit                                                     ; ошибка выполнения операции

                ; инициализация привода
.Drive          EQU $+1
                LD A, #00
                LD C, TRDOS.INIT_DRIVE                                          ; номер подпрограммы #01 (инициализация привода)
                CALL Jump3D13                                                   ; переход в TR-DOS
                JR C, .Exit                                                     ; ошибка выполнения операции

                ; считывание системного сектора и настройка контроллера на тип дискеты
                LD C, TRDOS.SET_DISK_TYPE
                CALL Jump3D13                                                   ; переход в TR-DOS

.Exit           ; восстановление позиция головки дисковода
                POP HL
                LD (TRDOS.CUR_SEC), HL
                RET

                endif ; ~ _TR_DOS_INITIALIZE_
