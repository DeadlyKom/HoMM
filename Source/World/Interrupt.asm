
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
                LD HL, GameSession.PeriodTick + FTick.Tile
                LD DE, GameState.TickCounter + FTick.Tile

                ; -----------------------------------------
                LD A, (HL)
                OR A
                JR NZ, $+7
                LD (HL), DURATION.TILE_TICK
                EX DE, HL
                INC (HL)
                EX DE, HL
                DEC (HL)
                ; -----------------------------------------

                INC L
                INC E

                ; -----------------------------------------
                LD A, (HL)
                OR A
                JR NZ, $+7
                LD (HL), DURATION.OBJECT_TICK
                EX DE, HL
                INC (HL)
                EX DE, HL
                DEC (HL)
                ; -----------------------------------------

                ifdef SHOW_FPS | _DEBUG
.Debug_FPS      ; ************** Draw FPS **************
                CALL FPS_Counter.Tick
                endif

                RET
    
                endif ; ~ _WORLD_LOCATION_INTERRUPT_
