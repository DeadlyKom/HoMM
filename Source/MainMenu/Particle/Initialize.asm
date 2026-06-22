
                ifndef _MAIN_MENU_PARTICLE_INITIALIZE_
                define _MAIN_MENU_PARTICLE_INITIALIZE_
; -----------------------------------------
; инициализация работы счастицами
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     ; обнуление счётчика элементов в массиве
                XOR A
                LD (Update.ParticleNum), A
                RET

                endif ; ~_MAIN_MENU_PARTICLE_INITIALIZE_
