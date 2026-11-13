
                ifndef _COMBAT_MAIN_INTERRUPT_
                define _COMBAT_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "сражения"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Interrupt:      SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Draw.Restore                                               ; восстановление фона под курсором

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

.RenderProcess  ; процесс отрисовки не завершён
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; обновление курсора
                CALL UI_Cursor.Update                                           ; обновление курсора
                CALL NC, UI_Cursor.Draw                                         ; вызов, если отображение курсора разрешено

.Input          ; ************ Scan Input ************
                SET_MODULE_PAGE_Combat                                          ; включить страницу модуля "сражения"
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Combat.Input.Scan                                       ; вызов обработки ввода, если сканирование разрешено

.Tick           ; *************** Tick ***************

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET
                display " - Main 'Combat' interrupt:\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"

                endif ; ~_COMBAT_MAIN_INTERRUPT_
