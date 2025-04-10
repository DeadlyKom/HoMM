
                ifndef _WORLD_LOCATION_INTERRUPT_
                define _WORLD_LOCATION_INTERRUPT_
; -----------------------------------------
; обработчик прерывания мира "локация"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Draw.Restore                                               ; восстановление фона под курсором

                ; проверка завершённости процесса отрисовки
                CHECK_RENDER_FLAG FINISHED_BIT
                JR Z, .RenderProcess                                            ; переход, если процесс отрисовки не завершён

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

.RenderProcess  ; процесс отрисовки не завершён
                
.Input          ; ************ Scan Input ************
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Input.Scan
                CALL Render.Cursor.Draw                                         ; отображение курсора

.Tick           ; *************** Tick ***************

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET
    
                endif ; ~ _WORLD_LOCATION_INTERRUPT_
