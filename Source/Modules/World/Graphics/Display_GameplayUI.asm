
                ifndef _MODULE_WORLD_DISPLAY_GAMEPLAY_UI_
                define _MODULE_WORLD_DISPLAY_GAMEPLAY_UI_
; -----------------------------------------
; отображение пользовательского интерфейса игрового окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameplayUI:     ; подготовка основного экрана
                ATTR_RECT_IPB SCR_ADR_BASE, 24, 9, 8, 15, BLACK, YELLOW, 1
                
                LD HL, BigDiamond
                CALL Draw.SpriteNotBound                                        ; отображение большого ромба

                LD A, #00
                LD DE, #50D4
                CALL .DrawIcon                                                  ; отображение иконки
                RET
; -----------------------------------------
; отображение иконки
; In:
;   DE - координаты в пикселях (D - y, E - x)
;   A - идентификатор иконки
; Out:
; Corrupt:
; Note:
; -----------------------------------------
.DrawIcon       ; расчёт адреса иконки
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD C, A
                LD B, #00
                LD HL, Icons
                ADD HL, BC
                LD A, (Kernel.Modules.World.Page)
                JP Draw.SpriteNotClipping.OR_XOR                                ; отображение спрайта иконки

                display " - Display gameplay UI:\t\t\t\t\t\t= busy [ ", /D, $-GameplayUI, " byte(s) ]"

                endif ; ~_MODULE_WORLD_DISPLAY_GAMEPLAY_UI_
