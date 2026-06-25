                ifndef _MAIN_MENU_PARTICLE_DRAW_
                define _MAIN_MENU_PARTICLE_DRAW_
; -----------------------------------------
; рисование активных частиц
; In:
; Out:
; Corrupt:
; Note:
;   отображение частиц выполняется после обновления экрана,
;   что позволяет сохронять значение экрана до рисования частицы
; -----------------------------------------
Draw:           SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                
                ; сброс указателя на последнюю пару дял восстановления экрана
                LD HL, Adr.RestoreBuf
                LD (RestoreScreen.Pointer), HL

                ; проверка налияия точек
                LD A, (UpdateParticles.ParticleNum)
                OR A
                RET Z                                                           ; выход, если массив пустой

                ; инициализация
                LD (.ContainerSP), SP                                           ; сохранени стека
                LD SP, HL
                LD IX, Adr.ParticleArray
                LD B, A

.Loop           ; определение адреса экрана
                LD H, HIGH Adr.ScrAdrTable
                LD L, (IX + FTargetParticle.Super.Position.Y.High)
                LD A, (HL)
                INC H
                LD D, (HL)

                ; корректировка адреса по горизонтали
                INC H
                LD L, (IX + FTargetParticle.Super.Position.X.High)
                OR (HL)
                LD E, A

                ; сохранение данных для восстановления
                PUSH DE                                                         ; сохранение адреса экрана в буфере восстановления
                RES 7, D                                                        ; сброс бита, переход на основной экран
                LD A, (DE)                                                      ; чтение байта для последующего восстановления
                PUSH AF                                                         ; сохранение байта экрана в буфере восстановления
                
                ; отображение точки на экране
                INC H
                OR (HL)
                LD (DE), A

                DJNZ .Loop

                ; сохранение указателя на последнюю пару дял восстановления экрана
                LD (RestoreScreen.Pointer), SP

.ContainerSP    EQU $+1
                LD SP, #0000
                RET

                endif ; ~_MAIN_MENU_PARTICLE_DRAW_
