
                ifndef _MODULE_WORLD_DISPLAY_GAME_WINDOW_
                define _MODULE_WORLD_DISPLAY_GAME_WINDOW_
; -----------------------------------------
; очистка screen block'ов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWindow:     ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                ; отображение рамки игрового окна
                RESTORE_BC                                                      ; защитная от порчи данных с разрешённым прерыванием
                LD HL, Frame
                CALL Draw.SpriteNotBound

                SHOW_BASE_SCREEN                                                ; отображение базового экрана

                ; подготовка теневого экрана
                CALL Func.ShadowScrcpyInPage                                    ; копирование экрана в теневой
                CALL Console.SetDrawToTwo                                       ; отображение консоли в 2х экранах
                JP_SHOW_SHADOW_SCREEN                                           ; отображение теневого экрана

.Ornament       ; отображение внутреннего орнамента рамки игрового окна
                LD HL, Ornament
                JP Draw.SpriteNotBound

                display " - Display game window:\t\t\t\t\t\t= busy [ ", /D, $-GameWindow, " byte(s) ]"

                endif ; ~_MODULE_WORLD_DISPLAY_GAME_WINDOW_
