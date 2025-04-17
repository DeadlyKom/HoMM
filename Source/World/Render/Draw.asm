
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
                ; первичная инициализация локации
                LD HL, Adr.BiomeBuf
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL

.Update         ; -----------------------------------------
                ; обновление
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                JR Z, .Tick

                CALL World.Tilemap.UpdateMovement                               ; обновление движения

.Tick           ; -----------------------------------------
                ; тик
                ; -----------------------------------------

                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"
                CALL Convert.DrawToHiddenScreen                                 ; установка работы функций со скрытым экраном
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)
                CALL Tilemap.Update                                             ; обновление положение камеры

                RESTORE_BC                                                      ; защитная от порчи данных с разрешённым прерыванием
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Draw.Background                                            ; отображение фона мира "локация"

                CALL World.Tilemap.VisibleObjects                               ; определение видимых объектов
                CALL NZ, Object.Draw                                            ; отображение объектов в массиве SortBuffer

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
                LD A, (World.Tilemap.VisibleObjects.VisibleSize + 0)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                LD A, (World.Tilemap.VisibleObjects.VisibleSize + 1)
                CALL Console.DrawByte
                ; -----------------------------------------

                ; -----------------------------------------
                ; отображение количество видимых объектов
                LD DE, #1712
                CALL Console.SetCursor
                LD A, (World.Tilemap.VisibleObjects.VisibleObjects)
                CALL Console.DrawByte
                ; -----------------------------------------

                endif

                RES_ALL_MAIN_FLAGS                                              ; сброс всех флагов
                SET_RENDER_FLAG FINISHED_BIT                                    ; установка флага завершения отрисовки
                RET

                endif ; ~_WORLD_RENDER_DRAW_
