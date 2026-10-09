
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
                CALL Draw.Restore                                               ; восстановление фона под курсором (только для OR_XOR_SAVE)

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

.RenderProcess  ; обновление курсора
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL UI_Cursor.Update                                           ; обновление курсора
                CALL C, UI_Cursor.Draw                                          ; вызов отображения курсора, если установлен флаг его отображения

.Input          ; ************ Scan Input ************
                SET_MODULE_PAGE_Inventory                                       ; включить страницу модуля "Inventory"
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
