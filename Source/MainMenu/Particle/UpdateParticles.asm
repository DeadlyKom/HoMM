
                ifndef _MAIN_MENU_PARTICLE_UPDATE_
                define _MAIN_MENU_PARTICLE_UPDATE_
; -----------------------------------------
; обновление позиции активных частиц
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
UpdateParticles:
.Damping        EQU 4                                                           ; демпфирование
                ; проверка наличие элементов в массиве
.ParticleNum    EQU $+1
                LD A, #00
                OR A
                RET Z                                                           ; выход, если массив пустой
                
                EX AF, AF'
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                EX AF, AF'

                ; инициализация
                LD IX, Adr.ParticleArray
                LD B, A

.Loop           ; -----------------------------------------
                ; проверка флага состоянии покоя
                ; -----------------------------------------
                BIT 0, (IX + FTargetParticle.Flags)
                JP NZ, .NextParticle                                            ; переход, если частица в состоянии покоя

                PUSH BC
                CALL .Calculate
                POP BC

.NextParticle   ; переход к следующей частице
                LD DE, TARGET_PARTICLE_SIZE
                ADD IX, DE

                DJNZ .Loop
                RET
                
.Calculate      ; расчёт оставшегося пути по горизонтали (dx)
                LD A, (IX + FTargetParticle.Target.X)
                SUB (IX + FTargetParticle.Super.Position.X.High)
                LD E, A                                                         ; дельта по горизонтали
                
                ; модуль |dx|
                JP P, $+5
                NEG
                LD C, A
                EX AF, AF'                                                      ; сохранение результата

                ; расчёт оставшегося пути по горизонтали (dy)
                LD A, (IX + FTargetParticle.Target.Y)
                SUB (IX + FTargetParticle.Super.Position.Y.High)
                LD D, A                                                         ; дельта по вертикали

                ; модуль |dy|
                JP P, $+5
                NEG
                LD B, A

                ; -----------------------------------------
                ; упращённый расчёт расстояние по дельте
                ;   max(|dx|, |dy|) + min(|dx|, |dy|) / 2
                ; -----------------------------------------
                LD L, C                                                         ; принудительно установить |dx| как большее
                CP C
                JR C, $+4                                                       ; переход, если |dx| > |dy|
                ; меняем местами |dx| и |dy|
                LD A, C         ; меньшее
                LD L, B         ; большее
                ; рассчёт расстояния
                SRL A           ; min(|dx|, |dy|) / 2
                ADD A, L        ; max(|dx|, |dy|) + min(|dx|, |dy|) / 2
                ; защита от переполнения
                JR NC, $+3
                SBC A, A
                
                ; -----------------------------------------
                ; расчёт силы по осям
                ; -----------------------------------------
                EXX
                LD H, HIGH Adr.ForceTable
                LD L, A

                ; чтение величины силы из таблицы (чем дальше частица от цели, тем слабее сила)
                LD E, (HL)
                INC H
                LD D, (HL)
                PUSH DE                                                         ; сохранения для следующего умножения

                ; расчёт силы по горизонтали
                EX AF, AF'  ; |dx|
                ; -----------------------------------------
                ; умножение DE на A
                ; In :
                ;   DE - множимое
                ;   A  - множитель
                ; Out :
                ;   HL - результат умножения DE * A
                ; Corrupt :
                ;   HL, F
                ; -----------------------------------------
                CALL Math.Mul16x8_16    ; (MUL_16x8_16)

                ; смена знака, если исходное значение было отрицательным
                EXX
                LD A, E     ; (dx)
                EXX
                ADD A, A    ; знак dx

                LD A, H
                JR NC, $+6

                ; NEG HL
                XOR A
                SUB L
                SBC A, A
                SUB H

                LD L, A
                ADD A, A
                SBC A, A
                LD H, A
                
                EX (SP), HL ; сохраним результат, и достанем значение силы из таблицы

                ; расчёт силы по вертикали  
                EXX
                LD A, B     ; |dy|
                EXX
                ; -----------------------------------------
                ; умножение DE на A
                ; In :
                ;   DE - множимое
                ;   A  - множитель
                ; Out :
                ;   HL - результат умножения DE * A
                ; Corrupt :
                ;   HL, F
                ; -----------------------------------------
                CALL Math.Mul16x8_16    ; (MUL_16x8_16)

                ; смена знака, если исходное значение было отрицательным
                EXX
                LD A, D     ; (dy)
                EXX
                ADD A, A    ; знак dy

                LD A, H
                JR NC, $+6

                ; NEG HL
                XOR A
                SUB L
                SBC A, A
                SUB H

                LD L, A
                ADD A, A
                SBC A, A
                LD H, A

                ; -----------------------------------------
                ; вертикаль
                ; -----------------------------------------
                ; расчёт демпфирования
                LD E, (IX + FTargetParticle.Super.Velocity.Y.High)
                LD A, (IX + FTargetParticle.Super.Velocity.Y.Low)
                LD C, A
                LD B, E

                rept -.Damping + 8
                SRA E
                RRA
                endr
                LD D, E
                LD E, A

                ; HL - расчётная сила по вертикали
                ; DE - расчётная сила торможения
                ; BC - старая скорость

                ; расчёт нового ускорения по вертикали
                OR A
                SBC HL, DE
                ADD HL, BC
                LD (IX + FTargetParticle.Super.Velocity.Y), HL

                ; расчёт нового положения по вертикали
                LD DE, (IX + FTargetParticle.Super.Position.Y)
                ADD HL, DE
                LD (IX + FTargetParticle.Super.Position.Y), HL
                ; -----------------------------------------

                ; -----------------------------------------
                ; горизонталь
                ; -----------------------------------------
                ; расчёт демпфирования
                LD E, (IX + FTargetParticle.Super.Velocity.X.High)
                LD A, (IX + FTargetParticle.Super.Velocity.X.Low)
                LD C, A
                LD B, E

                rept -.Damping + 8
                SRA E
                RRA
                endr
                LD D, E
                LD E, A

                POP HL
                ; HL - расчётная сила по горизонтали
                ; DE - расчётная сила торможения
                ; BC - старая скорость

                ; расчёт нового ускорения по горизонтали
                OR A
                SBC HL, DE
                ADD HL, BC
                LD (IX + FTargetParticle.Super.Velocity.X), HL

                ; расчёт нового положения по горизонтали
                LD DE, (IX + FTargetParticle.Super.Position.X)
                ADD HL, DE
                LD (IX + FTargetParticle.Super.Position.X), HL
                ; -----------------------------------------
                EXX
                RET

                endif ; ~_MAIN_MENU_PARTICLE_UPDATE_
