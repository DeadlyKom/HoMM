
                ifndef _MAIN_MENU_RENDER_DRAW_PORTAL_
                define _MAIN_MENU_RENDER_DRAW_PORTAL_
; состояние портала
PORTAL_STATE_OPEN   EQU #00                                                     ; открытие
PORTAL_STATE_LOOP   EQU #01                                                     ; зацикленный
PORTAL_STATE_CLOSE  EQU #02                                                     ; закрытие
Frame:
.Open           EQU 16
.Loop           EQU 0
.Close          EQU 0

; -----------------------------------------
; инициализация "портала"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Portal:
.Initialize     ; инициализация значений
                LD A, PORTAL_STATE_OPEN
                LD (.CurrentState), A
                INC A   ; #FF
                LD (.FrameIntLeft), A

                ; установка адреса структуры нулевого кадра
                LD HL, MainMenu.Base.Content.Portal.Adr.FrameArray
                LD (.FrameNum), HL

                ; сброс флага завершения
                RES_FLAG_MODIFY MainMenu.Base.Render.Portal.Flag
                RET
; -----------------------------------------
; проигрывание анимации "портала"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
.Play           CHECK_MAIN_FLAG ML_TRANSITION_BIT
                RET NZ

                ; проверка флага завершения
.Flag           EQU $
                NOP
                RET C                                                           ; выход, если проигрывание завершено
                
                ; уменьшение счётчика
                LD HL, .FrameIntLeft
                DEC (HL)
                RET NZ                                                          ; выход, если счётчик не обнулён

                EX DE, HL
.FrameNum       EQU $+1                                                         ; номер текущего кадра
                LD HL, MainMenu.Base.Content.Portal.Adr.FrameArray
                
                ; чтение продолжительности кадра в прерываниях (1/50)
                LD A, (HL)                                                      ; FFrame.Duration
                INC HL
                LD (DE), A                                                      ; сохранение нового счётчика

                ; чтение страницы в которой расположен кадр
                LD A, (HL)                                                      ; Frame.Address.Page
                INC HL
                SET_PAGE_A                                                      ; включение страницы кадра
                
                ; чтение адреса расположения кадра
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                LD (.FrameNum), HL
                PUSH DE                                                         ; адрес функции обновления

.State          ; состояние
.CurrentState   EQU $+1                                                         ; состояни портала
                LD A, #00
                OR A
                JR Z, .StateOpen
                DEC A
                JR Z, .StateLoop

; состояние портала - закрытие
.StateClose     ; ToDo: добавит копирование из буфера до 64 элементов следующей цепочки
                POP DE                                                          ; удаление адреса состека (неверный)

                ; установка флага завершения
                SET_FLAG_MODIFY MainMenu.Base.Render.Portal.Flag
                RET

; состояние портала - зацикленный  
.StateLoop      ; ToDo: добавит копирование из буфера до 64 элементов следующей цепочки
                POP DE                                                          ; удаление адреса состека (неверный)

                ; переход к следующему состоянию
                LD A, PORTAL_STATE_CLOSE
                JR .SetState

; состояние портала - открытие
.StateOpen      ; проверка достижения последнего кадра в текущем состоянии
                LD A, (.FrameNum)
                AND %11111100
                CP Frame.Open << 2
                RET NZ                                                          ; выход, если не достигли последнего кадра

                ; ToDo: добавит копирование из буфера до 64 элементов следующей цепочки
                POP DE                                                          ; удаление адреса состека (неверный)
                JP Portal.Initialize    ; ToDo: временно!

                ; переход к следующему состоянию
                LD A, PORTAL_STATE_LOOP

; установка состояния
.SetState       LD (.CurrentState), A
                RET
.FrameIntLeft   DB #00                                                          ; осталось прерываний до смены кадра

                endif ; ~_MAIN_MENU_RENDER_DRAW_PORTAL_
