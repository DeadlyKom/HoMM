
                ifndef _MAIN_MENU_MAIN_INTERRUPT_
                define _MAIN_MENU_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "гланого меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      ; проверка завершённости процесса отрисовки
                CHECK_RENDER_FLAG FINISHED_BIT
                JR Z, .RenderProcess                                            ; переход, если процесс отрисовки не завершён

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

.RenderProcess  ; процесс отрисовки не завершён

.Input          ; ************ Scan Input ************
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Input.Scan

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET

                display " - Main interrupt:\t\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"
    
                endif ; ~ _MAIN_MENU_MAIN_INTERRUPT_
