
                ifndef _MAIN_MENU_PARTICLE_REMOVE_AT_SWAP_
                define _MAIN_MENU_PARTICLE_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление элемента, перемещая последний элемент в массиве
; In:
;   IY - адрес удаляемого элемента
; Out:
;   HL - новый адрес элемента, если перемещён
;   флаг переполнения установлен, если небыло перемещение при удалении
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
RemoveAtSwap:   ; инициализация
                LD HL, UpdateParticles.ParticleNum
                DEC (HL)
                LD A, (HL)                                                      ; чтение количества элементов в массиве объектов
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если массив пуст

                ; расчёт индекса удаляемого элемента
                PUSH IY
                POP HL

                ; копирование адреса удаляемого элемента
                LD D, H
                LD E, L

                if TARGET_PARTICLE_SIZE > 16
                error "address calculation error"
                endif

                ; проверка на последний удаляемый элемент в массиве
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                CP H
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * TARGET_PARTICLE_SIZE
                LD H, #00
                LD L, A
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                LD A, H
                ADD A, HIGH Adr.ParticleArray
                LD H, A

                PUSH HL
                PUSH DE

                ifdef _OPTIMIZE
                rept TARGET_PARTICLE_SIZE
                LDI
                endr
                else
                LD BC, TARGET_PARTICLE_SIZE
                CALL Memcpy.FastLDIR
                endif

                POP DE
                POP HL

                OR A                                                            ; сброс флага, произведено пермещение
                RET

                endif ; ~_MAIN_MENU_PARTICLE_REMOVE_AT_SWAP_
