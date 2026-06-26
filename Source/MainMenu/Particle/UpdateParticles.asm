
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
.Damping        EQU 5                                                           ; демпфирование
                ; проверка наличие элементов в массиве
.ParticleNum    EQU $+1
                LD A, #00
                OR A
                RET Z                                                           ; выход, если массив пустой
                
                EX AF, AF'
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                EX AF, AF'

                ; инициализация
                LD IY, Adr.ParticleArray
                LD B, A

.Loop           ; -----------------------------------------
                ; проверка флага состоянии покоя
                ; -----------------------------------------
                BIT 0, (IY + FTargetParticle.Flags)
                JP NZ, .NextParticle                                            ; переход, если частица в состоянии покоя

                PUSH BC
                CALL .Calculate
                POP BC

                ; флаг переполнения установлен, если удалён последний элемент в массиве
                ; не требуется дополнительных действий
                ;
                ; флаг переполнения сброшен
                ; требуется дополнительные действие:
                ; - уменьшить счётчик обрабатываемых элементов
                ; - не увеличивать адрес следуюзего элемента
                JR C, .NextParticle

                DEC B
                RET Z                                                           ; выход, если счётчик обрабатываемых элементов обнулился

                DJNZ .Loop
                RET

.NextParticle   ; переход к следующей частице
                LD DE, TARGET_PARTICLE_SIZE
                ADD IY, DE

                DJNZ .Loop
                RET
                
.Calculate      ; расчёт оставшегося пути по горизонтали (dx)
                LD A, (IY + FTargetParticle.Target.X)
                SUB (IY + FTargetParticle.Super.Position.X.High)
                LD E, A                                                         ; дельта по горизонтали
                
                ; модуль |dx|
                JP P, $+5
                NEG
                LD C, A
                EX AF, AF'                                                      ; сохранение результата

                ; расчёт оставшегося пути по горизонтали (dy)
                LD A, (IY + FTargetParticle.Target.Y)
                SUB (IY + FTargetParticle.Super.Position.Y.High)
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

                CP #01
                JR NC, .L1

                LD H, A
                LD A, (IY + FTargetParticle.Super.Velocity.X.High)
                ; OR (IY + FTargetParticle.Super.Velocity.X.Low)
                OR (IY + FTargetParticle.Super.Velocity.Y.High)
                ; OR (IY + FTargetParticle.Super.Velocity.Y.Low)
                JP Z, .Remove
                LD A, H

.L1    
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
                LD E, (IY + FTargetParticle.Super.Velocity.Y.High)
                LD A, (IY + FTargetParticle.Super.Velocity.Y.Low)
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
                LD (IY + FTargetParticle.Super.Velocity.Y), HL

                ; расчёт нового положения по вертикали
                LD DE, (IY + FTargetParticle.Super.Position.Y)
                ADD HL, DE
                LD (IY + FTargetParticle.Super.Position.Y), HL
                ; -----------------------------------------

                ; -----------------------------------------
                ; горизонталь
                ; -----------------------------------------
                ; расчёт демпфирования
                LD E, (IY + FTargetParticle.Super.Velocity.X.High)
                LD A, (IY + FTargetParticle.Super.Velocity.X.Low)
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
                LD (IY + FTargetParticle.Super.Velocity.X), HL

                ; расчёт нового положения по горизонтали
                LD DE, (IY + FTargetParticle.Super.Position.X)
                ADD HL, DE
                LD (IY + FTargetParticle.Super.Position.X), HL
                ; -----------------------------------------
                EXX
                
                SCF                                                             ; флаг установлен
                                                                                ; не требуется дополнительных действий
                RET

.Remove         ; определение адреса экрана
                LD H, HIGH Adr.ScrAdrTable
                LD L, (IY + FTargetParticle.Target.Y)
                LD A, (HL)
                INC H
                LD D, (HL)

                ; корректировка адреса по горизонтали
                INC H
                LD L, (IY + FTargetParticle.Target.X)
                OR (HL)
                LD E, A

                ; отображение точки на экране
                LD A, (DE)                                                      ; чтение байта для последующего восстановления
                INC H
                XOR (HL)
                LD (DE), A

                JP RemoveAtSwap                                                 ; флаг переполнения установлен, если удалён последний элемент в массиве
                                                                                ; не требуется дополнительных действий
                                                                                ;
                                                                                ; флаг переполнения сброшен
                                                                                ; требуется дополнительные действие:
                                                                                ; - уменьшить счётчик обрабатываемых элементов
                                                                                ; - не увеличивать адрес следуюзего элемента

                endif ; ~_MAIN_MENU_PARTICLE_UPDATE_
