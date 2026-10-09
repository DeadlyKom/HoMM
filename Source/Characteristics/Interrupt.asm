
                ifndef _CHARACTERISTICS_MAIN_INTERRUPT_
                define _CHARACTERISTICS_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "характеристик"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Draw.Restore                                               ; восстановление фона под курсором (только для OR_XOR_SAVE)

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

.RenderProcess  ; процесс отрисовки не завершён
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL UI_Cursor.Update                                           ; обновление курсора
                CALL C, UI_Cursor.Draw                                          ; отображение курсора
                
.Input          ; ************ Scan Input ************
                SET_MODULE_PAGE_Characteristics                                 ; включить страницу модуля "Characteristics"
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Characteristics.Input.Scan

.Tick           ; *************** Tick ***************

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET

                display " - Main 'Characteristics' interrupt:\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"

                endif ; ~_CHARACTERISTICS_MAIN_INTERRUPT_
