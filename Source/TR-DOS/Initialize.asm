
                ifndef _TR_DOS_INITIALIZE_
                define _TR_DOS_INITIALIZE_
; -----------------------------------------
; инициализация работы с TR-DOS
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     ; установка адреса обработки ошибок работы TR-DOS
                LD A, #C3                                                       ; JP
                LD (TRDOS.WITH_RET + 0), A
                LD HL, ErrorHandler                                             ; адрес обработчика ошибок
                LD (TRDOS.WITH_RET + 1), HL
                
                ; сброс переменных перед инициализацией
                XOR A

                ; сброс дисководов
                LD HL, TRDOS.DRIVE_A
                LD (HL), A                                                      ; дисковод "А"
                INC L
                LD (HL), A                                                      ; дисковод "B"
                INC L
                LD (HL), A                                                      ; дисковод "C"
                INC L
                LD (HL), A                                                      ; дисковод "D"

                ; сброс времени перемещения головки дисковода
                LD HL, TRDOS.RATE_A
                DEC A
                LD (HL), A                                                      ; дисковод "А"
                INC L
                LD (HL), A                                                      ; дисковод "B"
                INC L
                LD (HL), A                                                      ; дисковод "C"
                INC L
                LD (HL), A                                                      ; дисковод "D"

                LD A, TRDOS.NUM_DRIVE_A
                CALL .InitDrive
                ; RET C
                LD A, TRDOS.NUM_DRIVE_B
                CALL .InitDrive
                ; RET C
                LD A, TRDOS.NUM_DRIVE_C
                CALL .InitDrive
                ; RET C
                LD A, TRDOS.NUM_DRIVE_D
                CALL .InitDrive
                RET
    
.InitDrive      ; сохранение номера инициализируемо привода
                LD (.Drive), A

                ; выполняется команда "Восстановление" ВГ93: головка отводится на нулевую 
                ; дорожку и ожидает сигнала INTRQ. Ожидание можно прервать нажатием клавиши BREAK
                LD C, TRDOS.RESTORE_VG93
                CALL Jump3D13                                                   ; переход в TR-DOS
                RET C                                                           ; ошибка выполнения операции

                ; инициализация привода
.Drive          EQU $+1
                LD A, #00
                LD C, TRDOS.INIT_DRIVE                                          ; номер подпрограммы #01 (инициализация привода)
                CALL Jump3D13                                                   ; переход в TR-DOS
                RET C                                                           ; ошибка выполнения операции

                ; считывание системного сектора и настройка контроллера на тип дискеты
                LD C, TRDOS.SET_DISK_TYPE
                JP Jump3D13                                                     ; переход в TR-DOS

                endif ; ~ _TR_DOS_INITIALIZE_
