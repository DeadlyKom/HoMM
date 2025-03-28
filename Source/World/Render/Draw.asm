
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
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)
                CALL Tilemap.Update                                             ; обновление положение камеры

                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                ; пока нет восстановление информации под спрайтов
                ; чистим весь экрна
                LD HL, #D800
                ADJUST_HIDDEN_SCR_ADR H                                         ; корректировка адреса скрытого экрана
                LD DE, #0000
                CALL SafeFill.Screen

                RESTORE_BC                                                      ; защитная от порчи данных с разрешённым прерыванием
                CALL Draw.Background                                            ; отображение фона мира "локация"
                LD HL, TestSprite
                CALL Draw.Sprite

                ifdef _DEBUG
                ; отображение позиции мыши на экране
                LD DE, #1700
                CALL Console.SetCursor
                LD A, (Mouse.PositionX)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                LD A, (Mouse.PositionY)
                CALL Console.DrawByte
                endif

                RES_ALL_MAIN_FLAGS                                              ; сброс всех флагов
                SET_RENDER_FLAG FINISHED_BIT                                    ; установка флага завершения отрисовки
                RET

TestSprite      FSprite {{8, 8, 0, 0}, SPR_OR_XOR | PAGE_5, #C000 | $+3}
                DB %11111111, %00000000
                DB %11111111, %01111110
                DB %11000011, %01000010
                DB %11000011, %01000010
                DB %11000011, %01000010
                DB %11000011, %01000010
                DB %11111111, %01111110
                DB %11111111, %00000000

                endif ; ~_WORLD_RENDER_DRAW_
