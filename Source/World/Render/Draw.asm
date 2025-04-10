
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

                LD HL, #0600
                LD (Kernel.Sprite.DrawClipped.PositionX), HL
                LD (Kernel.Sprite.DrawClipped.PositionY), HL

                LD HL, Teleport.Sprites
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

                include "Builder/Assets/Graphics/Original/Environment/Teleport/Include.inc"

                endif ; ~_WORLD_RENDER_DRAW_
