
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
                LD HL, Update.ParticleNum

                ; проверка переполнения массива
                LD A, (HL)
                CP MAX_TARGET_PARTICLE
                CCF
                RET C                                                           ; выход, если нет места для размещения элемента

                INC (HL)                                                        ; увеличение счётчика элементов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента

                if TARGET_PARTICLE_SIZE > 12
                error "address calculation error"
                endif

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * TARGET_PARTICLE_SIZE
                LD H, #00
                LD D, H
                LD E, L
                ADD HL, HL  ; x2
                ADD HL, DE  ; x3
                ADD HL, HL  ; x6
                ADD HL, HL  ; x12
                EX DE, HL
                LD IY, Adr.ParticleArray
                ADD IY, DE

                RET

                endif ; ~_MAIN_MENU_PARTICLE_PLACEMENT_NEW_
