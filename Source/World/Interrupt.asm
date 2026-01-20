
                ifndef _WORLD_MAIN_INTERRUPT_
                define _WORLD_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; CALL Draw.Restore                                               ; восстановление фона под курсором - ОТКЛ

                ; проверка готовности кадра
                CHECK_RENDER_FLAG FRAME_READY_BIT
                JR Z, .RenderProcess                                            ; переход, если кадр не готов

.SwapScreens    ; ************ Swap Screens ************
                CALL Render.Swap

                ; проверка флага ожидания переключения экрана, но он не выполнен
                CHECK_RENDER_FLAG SWAP_PENDING_BIT
                JR NZ, .RenderProcess                                           ; переход, если в ожидании переключения экрана
                                                                                ; используется, если спереключение экрана мб дольше фрейма
                ; --------------------------------------------------------------
                ; инициализация счётчиков, и смена кадров, 
                ; если счётчикни обнулены
                LD HL, GameSession.PeriodTick + FTick.Tile
                LD DE, GameState.TickCounter + FTick.Tile

                LD A, (HL)
                OR A
                JR NZ, $+7
                LD (HL), DURATION.TILE_TICK+1
                EX DE, HL
                INC (HL)
                EX DE, HL

                INC L
                INC E

                LD A, (HL)
                OR A
                JR NZ, $+7
                LD (HL), DURATION.HERO_TICK+1
                EX DE, HL
                INC (HL)
                EX DE, HL

                INC L
                INC E

                LD A, (HL)
                OR A
                JR NZ, $+6
                LD (HL), DURATION.OBJECT_TICK+1
                EX DE, HL
                INC (HL)
                ; --------------------------------------------------------------

.RenderProcess  ; процесс отрисовки не завершён
                ; CALL Render.Cursor.Draw                                         ; отображение курсора - ОТКЛ
                
.Input          ; ************ Scan Input ************
                CHECK_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                         ; проверка разрешения сканирования ввода
                CALL Z, Input.Scan

.Tick           ; *************** Tick ***************

                ; -----------------------------------------
                ; уменьшение счётчиков периодов, без переполнения
                LD HL, GameSession.PeriodTick + FTick.Scroll
                LD BC, #0001

                ; уменьшение счётчика задержки скрола карты
                LD A, (HL)
                SUB C
                ADC A, B
                LD (HL), A

                INC L

                ; уменьшение счётчика задержки тайлов
                LD A, (HL)
                SUB C
                ADC A, B
                LD (HL), A

                INC L

                ; уменьшение счётчика задержки героя
                LD A, (HL)
                SUB C
                ADC A, B
                LD (HL), A

                INC L

                ; уменьшение счётчика задержки объектов
                LD A, (HL)
                SUB C
                ADC A, B
                LD (HL), A
                ; -----------------------------------------

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CHECK_INTERRUPT_FLAG INT_DISABLE_GLOBAL_TICK_BIT                ; проверка разрешения глобального тика
                CALL Z, Tick.Global                                             ; обработчик глобального тика

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET

                display " - Main interrupt:\t\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"
    
                endif ; ~ _WORLD_MAIN_INTERRUPT_
