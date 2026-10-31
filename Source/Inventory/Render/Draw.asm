
                ifndef _INVENTORY_RENDER_DRAW_
                define _INVENTORY_RENDER_DRAW_
; -----------------------------------------
; отображение "инвентаря"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Draw:           ; -----------------------------------------
                ; точка входа отображения
                ; -----------------------------------------

.Transiton      ; -----------------------------------------
                ; переход между циклами
                ; -----------------------------------------
                ; проверка запроса перехода между циклами
                CHECK_MAIN_FLAG ML_TRANSITION_BIT
                JR Z, .Enter                                                    ; переход, если переход между циклами не запрошен

.Enter          ; -----------------------------------------
                ; первичная инициализация
                ; -----------------------------------------
                ; проверка запроса первичной инициализации
                CHECK_MAIN_FLAG ML_ENTER_BIT
                JR Z, .Update                                                   ; переход, если первичная инициализация не запрошена

                ; сброс возможности восстановления фона курсора
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                LD HL, Adr.CursorStorageA
                LD (HL), #00                                                    ; 0 байт хранит данные о размере заполнения
                INC H
                LD (HL), #00                                                    ; 0 байт хранит данные о размере заполнения
                RES_FLAG_MODIFY CursorCopyGate.Flag                              ; разрешение работы с буфером курсора

.Update         ; -----------------------------------------
                ; обновление
                ; -----------------------------------------
                ; проверка запроса обновления
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                JR Z, .Tick                                                     ; переход, если обновление не запрошено
   
                RES_MAIN_FLAG ML_UPDATE_BIT                                     ; сброс обрабатываемого запроса обновления
                SET_RENDER_FLAGS FRAME_READY | SWAP_PENDING                     ; установка флагов готовности кадра и переноса экранов
                RET

.Tick           ; -----------------------------------------
                ; тик
                ; -----------------------------------------

                SET_MODULE_PAGE_Inventory                                       ; включение страницы модуля инвентаря
                CALL UI.Update                                                  ; обновление UI

                ; проверка запроса перерисовки фона
                LD HL, Inventory.States.HoveredItem.Flags
                CHECK_FLAG INVENTORY_REDRAW_BIT
                CALL NZ, Inventory.Display.Window.Redraw                        ; вызов, если запрошена перерисовка фона
                CALL Inventory.Display.Slots                                    ; обработка анимации и отображение слотов
                CALL Inventory.Display.Description                              ; обработка запроса и перерисовка описания

                ifdef _DEBUG
                CALL Inventory.Display.DebugInfo                                ; отображение отладочной информации об инвентаре
                endif

                ; сброс обработанных флагов входа и перехода
                RES_MAIN_FLAGS ML_ENTER | ML_TRANSITION
                RET
                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_INVENTORY_RENDER_DRAW_
