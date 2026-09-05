
                ifndef _MODULE_WORLD_LAUNCH_GAMEPLAY_WINDOW_
                define _MODULE_WORLD_LAUNCH_GAMEPLAY_WINDOW_
; -----------------------------------------
; отображение игрового окна
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
GameplayWindow: ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                SET_RENDER_TO_BASE_SCREEN                                       ; установка работы с основным экраном
                CALL World.Display.GameplayFrame                                ; отображение рамки игрового окна
                CALL World.Display.GameplayUI                                   ; отображение пользовательского интерфейса игрового окна
                SET_WORLD_CHRONO_FLAG WORLD_DAY_PHASE_UPDATE_BIT                ; запрос начального отображения фазы суток
                CALL World.Display.DiamondChrono.Initialize                     ; инициализация отображения фазы суток

                SHOW_BASE_SCREEN                                                ; отображение базового экрана

                ; подготовка теневого экрана
                CALL Func.ShadowScrcpyInPage                                    ; копирование экрана в теневой
                RES_FLAG_MODIFY World.Base.Render.PipelineHexagons.DiamondFlag  ; сброс запроса переноса ромба после полной копии экрана
                CALL Console.SetDrawToTwo                                       ; отображение консоли в 2х экранах
                JP_SHOW_SHADOW_SCREEN                                           ; отображение теневого экрана

                display " - Display gameplay window:\t\t\t\t\t\t= busy [ ", /D, $-GameplayWindow, " byte(s) ]"

                endif ; ~_MODULE_WORLD_LAUNCH_GAMEPLAY_WINDOW_
