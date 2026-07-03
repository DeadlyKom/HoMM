
                ifndef _MAIN_MENU_MAIN_INTERRUPT_
                define _MAIN_MENU_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "гланого меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      
.Input          ; ************ Scan Input ************
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Input.Scan

.Render         ; ************** Render **************
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; период обновления 4 фрейма, позволяя распредлеить нагрузку в начале кадра
                LD A, (TickCounterRef)
                AND %00000011
                LD HL, .ManageTable
                CALL Func.JumpTable

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif
.RET            RET
.ManageTable    ; таблица распределения времени
                DW MainMenu.Base.Render.ActivateIntro                           ; активации пропуска интро
                DW MainMenu.Base.Render.FlushIntro                              ; высвободение завершения интро
                DW MainMenu.Base.Render.CompliteIntro                           ; завершение пропуска интро
                DW MainMenu.Base.Render.UpdateScreen                            ; обновление экрана

                display " - Main interrupt:\t\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"
    
                endif ; ~ _MAIN_MENU_MAIN_INTERRUPT_
