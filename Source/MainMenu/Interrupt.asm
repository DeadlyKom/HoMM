
                ifndef _MAIN_MENU_MAIN_INTERRUPT_
                define _MAIN_MENU_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "гланого меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      ; период обновления 4 фрейма, позволяя распредлеить нагрузку в начале кадра
                LD A, (TickCounterRef)
                AND %00000011
                LD HL, .JumpTable
                CALL Func.JumpTable

.Input          ; ************ Scan Input ************
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Input.Scan

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

.RET           RET

.JumpTable      DW MainMenu.Base.Render.UpdateScreen                            ; обновление экрана
                DW MainMenu.Base.Render.Portal.Play                             ; проигрывание анимации "портала"
                 ; MainMenu.Base.Particle.Draw                                  ; отображение частиц
                DW .RET                                                         ; бездействие
                DW .RET                                                         ; бездействие

                display " - Main interrupt:\t\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"
    
                endif ; ~ _MAIN_MENU_MAIN_INTERRUPT_
