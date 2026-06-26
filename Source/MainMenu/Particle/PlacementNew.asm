
                ifndef _MAIN_MENU_PARTICLE_PLACEMENT_NEW_
                define _MAIN_MENU_PARTICLE_PLACEMENT_NEW_
; -----------------------------------------
; размещение нового объекта
; In:
; Out:
;   A' - текущий ID объекта
;   IY - адрес свободного элемента
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   HL, AF, AF'
; Note:
; -----------------------------------------
PlacemantNew    ; инициализация
                LD HL, UpdateParticles.ParticleNum

                ; проверка переполнения массива
                LD A, (HL)
                CP MAX_TARGET_PARTICLE
                CCF
                RET C                                                           ; выход, если нет места для размещения элемента

                INC (HL)                                                        ; увеличение счётчика элементов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента

                if TARGET_PARTICLE_SIZE > 16
                error "address calculation error"
                endif

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * TARGET_PARTICLE_SIZE
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                EX DE, HL
                LD IY, Adr.ParticleArray
                ADD IY, DE

                RET

                endif ; ~_MAIN_MENU_PARTICLE_PLACEMENT_NEW_
