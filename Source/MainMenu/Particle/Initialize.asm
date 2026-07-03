
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
                LD (UpdateParticles.ParticleNum), A

                ; установка количество свободных элементов в буфере очереди точек
                LD A, Size.PointQueue
                LD (RefillPointQueue.NumAvailable), A
                
                ; установка адрес буфера очереди точек
                LD HL, Adr.PointQueue
                LD (RefillPointQueue.Pointer), HL

                ; установка адрес буфера восстановления экрана
                LD HL, Adr.RestoreBuf
                LD (RestoreScreen.Pointer), HL

                ; сброс флага установки базовой линии
                RES_FLAG_MODIFY RefillPointQueue.BaselineFlag
                RET

                endif ; ~_MAIN_MENU_PARTICLE_INITIALIZE_
