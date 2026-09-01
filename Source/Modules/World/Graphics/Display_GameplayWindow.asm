
                ifndef _MODULE_WORLD_DISPLAY_GAMEPLAY_WINDOW_
                define _MODULE_WORLD_DISPLAY_GAMEPLAY_WINDOW_
; -----------------------------------------
; очистка screen block'ов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameplayWindow: ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                SET_RENDER_TO_BASE_SCREEN                                       ; установка работы с основным экраном
                CALL GameplayFrame                                              ; отображение рамки игрового окна
                CALL GameplayUI                                                 ; отображение пользовательского интерфейса игрового окна

                SHOW_BASE_SCREEN                                                ; отображение базового экрана

                ; подготовка теневого экрана
                CALL Func.ShadowScrcpyInPage                                    ; копирование экрана в теневой
                CALL Console.SetDrawToTwo                                       ; отображение консоли в 2х экранах
                JP_SHOW_SHADOW_SCREEN                                           ; отображение теневого экрана

                display " - Display gameplay window:\t\t\t\t\t\t= busy [ ", /D, $-GameplayWindow, " byte(s) ]"

                endif ; ~_MODULE_WORLD_DISPLAY_GAMEPLAY_WINDOW_
