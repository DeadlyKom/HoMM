                ifndef _MAIN_MENU_PARTICLE_RESTORE_SCREEN_
                define _MAIN_MENU_PARTICLE_RESTORE_SCREEN_
; -----------------------------------------
; восстановление экрана
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу теневого экрана (страница 7)
; -----------------------------------------
RestoreScreen:  ; проверка налияия точек
                LD HL, Adr.RestoreBuf
.Pointer        EQU $+1                                                         ; указатель на последнюю пару восстановления
                LD DE, #0000
                OR A
                SBC HL, DE
                LD A, L
                OR A
                RET Z                                                           ; выход, если массив пустой (указатель указывает на начало буфера)

                ; инициализация
                LD (.ContainerSP), SP                                           ; сохранени стека
                EX DE, HL
                LD SP, HL
                RRA     ; /2
                SRA A   ; /4
                LD B, A
                
.Loop           POP AF                                                          ; чтение байта экрана из буфере
                POP HL                                                          ; чтение адреса экрана из буфера
                LD (HL), A                                                      ; восстановление байта экрана
                DJNZ .Loop

.ContainerSP    EQU $+1
                LD SP, #0000
                RET

                endif ; ~_MAIN_MENU_PARTICLE_RESTORE_SCREEN_
