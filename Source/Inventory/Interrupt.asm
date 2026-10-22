
                ifndef _INVENTORY_MAIN_INTERRUPT_
                define _INVENTORY_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "инвентаря"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Interrupt:      SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; проверка разрешения восстановления фона курсора
                CALL Render.CursorCopyGate
                CALL NC, Draw.Restore                                           ; вызов восстановления, если работа с буфером курсора разрешена

                ; проверка готовности кадра к показу
                CHECK_RENDER_FLAG FRAME_READY_BIT
                JR Z, .RenderProcess                                            ; переход, если готовый кадр отсутствует

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

.RenderProcess  ; обновление курсора
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; проверка разрешения обновления курсора
                CALL Render.CursorCopyGate
                JR C, .Input                                                    ; переход, если выполняется перенос кадра
                CALL UI_Cursor.Update                                           ; обновление курсора
                CALL C, UI_Cursor.Draw                                          ; вызов отображения курсора, если установлен флаг его отображения

.Input          ; ************ Scan Input ************
                SET_MODULE_PAGE_Inventory                                       ; включить страницу модуля "инвентаря"
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Inventory.Input.Scan                                    ; вызов обработки ввода, если сканирование разрешено

.Tick           ; *************** Tick ***************

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET

                display " - Main 'Inventory' interrupt:\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"

                endif ; ~_INVENTORY_MAIN_INTERRUPT_
