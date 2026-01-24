
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
                CALL Draw.Restore                                               ; восстановление фона под курсором (только для OR_XOR_SAVE)

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
                CALL Render.Cursor.Draw                                         ; отображение курсора
                
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

.Memcpy         LD (.Container_SP), SP                                          ; сохранить исходный указатель стека
                LD SP, Int.StackTop                                             ; использовать стек прерывания
                PUSH AF
                PUSH HL
                PUSH DE

.Container_SP   EQU $+1
                LD HL, #0000
                DEC HL

                BIT 7, H
                JR NZ, .CorruptShadow
                
                ; испорчен основной экран
                ; копирование 2х байт их теневого экрана
                SET 7, H
                LD E, (HL)
                DEC HL
                LD D, (HL)

                RES 7, H
                LD (HL), D
                INC HL
                LD (HL), E
                JR .Continue

.CorruptShadow  ; испорчен теневой экран
                ; копирование 2х байт их основного экрана
                RES 7, H
                LD E, (HL)
                DEC HL
                LD D, (HL)

                SET 7, H
                LD (HL), D
                INC HL
                LD (HL), E

.Continue       POP DE
                POP HL
                POP AF
                JP Bootloader.KernelMinimal.Interrupt.Handler.SaveRegs

                display " - Main interrupt:\t\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"
    
                endif ; ~ _WORLD_MAIN_INTERRUPT_
