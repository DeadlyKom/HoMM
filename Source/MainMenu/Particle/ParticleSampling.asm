                ifndef _MAIN_MENU_PARTICLE_SAMPLING_
                define _MAIN_MENU_PARTICLE_SAMPLING_
; -----------------------------------------
; выборка частиц из очереди точек
; In:
; Out:
;   IY - адрес свободного элемента
; Corrupt:
; Note:
; -----------------------------------------
ParticleSampling:
                ; определение количество доступных элементов в буфере очереди точек
                LD A, (RefillPointQueue.NumAvailable)
                NEG
                ADD A, Size.PointQueue
                OR A
                RET Z                                                           ; выход, если буфер очереди точек пустой
                EX AF, AF'

                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; инициализация
                EX AF, AF'
                LD C, A
                LD B, Size.Particle

.Loop           EXX
                CALL Math.Rand8
                ; -----------------------------------------
                ; деление D на E
                ; In:
                ;   D - делимое
                ;   E - делитель
                ; Out:
                ;   D - результат деления (D / E)
                ;   A - остаток (D % E)
                ; Corrupt:
                ;   D, AF
                ; -----------------------------------------
                LD D, A
                EXX
                LD A, C
                EXX
                LD E, A
                CALL Math.Div8x8                                                ; mod

                ; чтение позиции назначения частицы
                ADD A, A
                LD L, A
                LD H, HIGH Adr.PointQueue
                LD C, (HL)      ; X
                INC HL
                LD B, (HL)      ; Y
                PUSH HL
                CALL .Initialize
                EXX
                POP DE
                RET C                                                           ; выход, если нет места для размещения частиц
                
                ; удаление частицы из буфере очереди точек (remove at swap)
                LD HL, (RefillPointQueue.Pointer)
                DEC HL
                LD A, (HL)
                LD (DE), A
                DEC HL
                DEC DE
                LD A, (HL)
                LD (DE), A
                LD (RefillPointQueue.Pointer), HL

                LD HL, RefillPointQueue.NumAvailable
                INC (HL)
                DEC C                                                           ; уменьшить количество доступных точек
                RET Z                                                           ; выход, если нет доступных точек

                DJNZ .Loop
                RET

.Initialize     CALL PlacemantNew
                RET C                                                           ; выход, если нет места для размещения частиц

                ; инициализация частицы
                LD (IY + FTargetParticle.Target), BC
                RES 0, (IY + FTargetParticle.Flags)                             ; сброс флага спокойствия

                LD (IY + FTargetParticle.Super.Position.X.High), 144            ; горизонтальное начало
                CALL Math.Rand8
                AND %00111111
                ADD A, 72-16
                LD (IY + FTargetParticle.Super.Position.Y.High), A              ; вертикальное начало 72 + 0..31

                XOR A
                LD (IY + FTargetParticle.Super.Position.X.Low), A
                LD (IY + FTargetParticle.Super.Position.Y.Low), A
                LD (IY + FTargetParticle.Super.Velocity.X.High), A
                LD (IY + FTargetParticle.Super.Velocity.X.Low), A
                LD (IY + FTargetParticle.Super.Velocity.Y.High), A
                LD (IY + FTargetParticle.Super.Velocity.Y.Low), A

                RET

; высвобождение подготовленных элементов в буфере очереди точек
.Flush          LD A, (RefillPointQueue.NumAvailable)
                NEG
                ADD A, Size.PointQueue-1
                OR A
                RET Z                                                           ; выход, если буфер очереди точек пустой

                ; инициализация
                LD HL, Adr.PointQueue

.FlushLoop      EX AF, AF'

                ; чтение координат точки
                LD C, (HL)      ; X
                INC HL
                LD B, (HL)      ; Y
                INC HL
                EX DE, HL

                ; определение адреса экрана
                LD H, HIGH Adr.ScrAdrTable
                LD L, B         ; Y
                LD A, (HL)
                INC H
                LD B, (HL)

                ; корректировка адреса по горизонтали
                INC H
                LD L, C         ; X
                OR (HL)
                LD C, A

                ; сохранение данных для восстановления
                RES 7, B                                                               ; сброс бита, переход на основной экран
                LD A, (BC)                                                      ; чтение байта для последующего восстановления
                
                ; отображение точки на экране
                INC H
                XOR (HL)
                LD (BC), A

                EX DE, HL
                EX AF, AF'
                DEC A
                JR NZ, .FlushLoop

                ; установка количество свободных элементов в буфере очереди точек
                LD A, Size.PointQueue
                LD (RefillPointQueue.NumAvailable), A

                ; установка адрес буфера очереди точек
                LD HL, Adr.PointQueue
                LD (RefillPointQueue.Pointer), HL                      

                RET

                endif ; ~_MAIN_MENU_PARTICLE_SAMPLING_
