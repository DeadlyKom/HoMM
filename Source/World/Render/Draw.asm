
                ifndef _WORLD_RENDER_DRAW_
                define _WORLD_RENDER_DRAW_
; -----------------------------------------
; отображение "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; -----------------------------------------
                ; точка входа отображения
                ; -----------------------------------------

.Transiton      ; -----------------------------------------
                ; переход между меню
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_TRANSITION_BIT
                JR Z, .Enter

.Enter          ; -----------------------------------------
                ; первичная инициализация
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_ENTER_BIT
                JR Z, .Update

                ; сброс возможности восстановления фона курсора
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                LD HL, Adr.TempBuffer + 2
                LD (HL), #00

                ; первичная инициализация локации
                LD HL, Adr.MapBiome
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL

.Update         ; -----------------------------------------
                ; обновление
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                JR Z, .Tick

.Tick           ; -----------------------------------------
                ; тик
                ; -----------------------------------------

                ; -----------------------------------------
                ; обновление позиции карты
                CHECK_SCROLL_FLAG SCROLL_MAP_BIT
                JR Z, $+14
                LD HL, GameSession.PeriodTick + FTick.Scroll
                LD A, (HL)
                OR A
                JR NZ, $+7
                LD (HL), DURATION.TILEMAP_SCROLL+1
                CALL World.Base.Tilemap.UpdateMovement                          ; обновление движения
                ; -----------------------------------------

                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"
                CALL Convert.DrawToHiddenScreen                                 ; установка работы функций со скрытым экраном
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)
                CALL Tilemap.Update                                             ; обновление положение камеры

                RESTORE_BC                                                      ; защитная от порчи данных с разрешённым прерыванием
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; CALL Draw.Background                                            ; отображение фона мира "локация" - СТАРОЕ
                CALL Draw.Hex.World

                ; CALL World.Base.Tilemap.VisibleObjects                          ; определение видимых объектов - ОТКЛ
                ; CALL NZ, Object.Draw                                            ; отображение объектов в массиве SortBuffer - ОТКЛ

                ifdef _DEBUG
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; -----------------------------------------
                ; отображение позиции мыши на экране
                LD DE, #1700
                CALL Console.SetCursor
                LD A, (Mouse.PositionX)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                LD A, (Mouse.PositionY)
                CALL Console.DrawByte
                ; -----------------------------------------

                ; -----------------------------------------
                ; отображение позиции карты
                LD DE, #1706
                CALL Console.SetCursor
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                CALL Console.DrawByte
                ; -----------------------------------------
                
                ; -----------------------------------------
                ; отображение размера видимой области в чанках
                LD DE, #170C
                CALL Console.SetCursor
                LD A, (World.Base.Tilemap.VisibleObjects.VisibleSize + 0)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                LD A, (World.Base.Tilemap.VisibleObjects.VisibleSize + 1)
                CALL Console.DrawByte
                ; -----------------------------------------

                ; -----------------------------------------
                ; отображение количество видимых объектов
                LD DE, #1712
                CALL Console.SetCursor
                LD A, (World.Base.Tilemap.VisibleObjects.Num)
                CALL Console.DrawByte
                ; -----------------------------------------

                endif

                RES_ALL_MAIN_FLAGS                                              ; сброс всех флагов
                SET_RENDER_FLAG FINISHED_BIT                                    ; установка флага завершения отрисовки
                JP World.Base.Event.Handler                                     ; обработчик событий

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_DRAW_
