
                ifndef _ASSETS_MANAGER_SELECT_DISK_
                define _ASSETS_MANAGER_SELECT_DISK_
; -----------------------------------------
; установить активный привод с требуемым диском
; In:
;   A  - номер дискеты
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SelectDisk:     ; 
                LD C, TRDOS.INIT_DRIVE                                          ; номер подпрограммы #01 (инициализация привода)
                                                                                ; -----------------------------------------
                                                                                ; A - номер привода
                                                                                ; -----------------------------------------
                LD (TRDOS.DEFAULT_DRV), A
                LD (TRDOS.TMP_DRIVE), A
                RET

                endif ; ~ _ASSETS_MANAGER_SELECT_DISK_
