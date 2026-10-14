
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
                LD HL, Adr.CursorStorageA
                LD (HL), #00                                                    ; 0 байт хранит данные о размере заполнения
                INC H
                LD (HL), #00                                                    ; 0 байт хранит данные о размере заполнения
                RES_FLAG_MODIFY CursorMemcpyGate.Flag                           ; разрешение работы с буфером курсора
                CALL ScreenBlock.Clear                                          ; очистка screen block'ов
                CALL Event.Initialize                                           ; инициализация работы с событиями

                ; обновление миникарты с учётом разведки и положения камеры
                CALL World.SharedCode.Render.Update.Minimap

                ; принудительное обновление Tilemap- и Render-буферов
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CALL World.SharedCode.Tilemap.Update.RenderBuffer
                CALL World.SharedCode.Tilemap.Update.TileBuffer
                CALL Draw.HexDLGeneration

.Update         ; -----------------------------------------
                ; обновление
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                JR Z, .Tick

.Tick           ; -----------------------------------------
                ; тик
                ; -----------------------------------------
                CALL Event.Handler.Before                                       ; обработчик событий (BEFORE_RENDER)
                ; -----------------------------------------
                ; проверка пересечения курсором UI элементов
                SET_MODULE_PAGE_World                                           ; включить страницу модуля "World"
                CALL UI.Update
                ; -----------------------------------------Ц
                ; обновление позиции карты
                CHECK_INPUT_TIMER_FLAG SCROLL_MAP_BIT
                CALL NZ, World.Tilemap.UpdateMovement
                ; -----------------------------------------
                ; обновление Tilemap- и Render-буферов
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CHECK_VIEW_FLAG UPDATE_RENDER_BUF_BIT
                CALL NZ, World.SharedCode.Tilemap.Update.RenderBuffer
                CHECK_VIEW_FLAG UPDATE_TILEMAP_BUF_BIT
                CALL NZ, World.SharedCode.Tilemap.Update.TileBuffer
                ; -----------------------------------------
                ; обновление анимации невидимых гексагонов
                CALL Buffer.Fog.Make
                CALL Buffer.Fog.Tick
                ; -----------------------------------------

                CALL PipelineHexagons
                ; -----------------------------------------
                CALL Event.Handler.After                                        ; обработчик событий (AFTER_RENDER)
                ; -----------------------------------------
                
                ifdef _DEBUG
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                SET_RENDER_TO_BASE_SCREEN                                       ; установка работы с основным экраном
                ifdef DEBUG_INFO_WORLD_TIME
                CALL WorldTime.DebugRender                                      ; отображение игрового календаря
                endif
                CALL DebugInfo                                                  ; отображение отладочной информации о мире
                endif

                RES_ALL_MAIN_FLAGS                                              ; сброс всех флагов
                RET
                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_DRAW_
