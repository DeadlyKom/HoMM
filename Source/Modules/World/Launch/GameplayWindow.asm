
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

                ; отображение текстуры ромба с фиксированной фазой
                LD HL, (Kernel.Modules.World.MemoryAddress)
                LD A, #80
                OR A                                                            ; прямое направление прохода текстуры
                CALL World.Display.DiamondTexture

                SHOW_BASE_SCREEN                                                ; отображение базового экрана

                ; подготовка теневого экрана
                CALL Func.ShadowScrcpyInPage                                    ; копирование экрана в теневой
                CALL Console.SetDrawToTwo                                       ; отображение консоли в 2х экранах
                JP_SHOW_SHADOW_SCREEN                                           ; отображение теневого экрана

                display " - Display gameplay window:\t\t\t\t\t\t= busy [ ", /D, $-GameplayWindow, " byte(s) ]"

                endif ; ~_MODULE_WORLD_LAUNCH_GAMEPLAY_WINDOW_
