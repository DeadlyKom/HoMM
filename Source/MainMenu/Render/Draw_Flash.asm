
                ifndef _MAIN_MENU_RENDER_DRAW_FLASH_
                define _MAIN_MENU_RENDER_DRAW_FLASH_
; -----------------------------------------
; отображение вспышку
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw_Flash:     ;
.Show           ; показать
                BORDER WHITE                                                    ; установка бордюра
                MEMCPY SCR_ATTR_BASE+32, #E900, ATTR_SIZE-32                         ; копирование блока атрибутов
                ATTR_IPB SCR_ADR_BASE, WHITE, WHITE, 0                          ; очистка атрибутов основного экрана
                SET_REG_PAIR_ATTR_IPB HL, WHITE, BLUE, 0
                SET_TO_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X, SCR_CHUR_POX_Y + 0
                SET_TO_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X, SCR_CHUR_POX_Y + 1
                SET_TO_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X, SCR_CHUR_POX_Y + 2
                CALL MainMenu.Base.Particle.RestoreScreen                       ; восстановление экрана
                CALL MainMenu.Base.Particle.Draw.Flush                          ; высвобождение частиц в массиве
                RET

.Hide           ; скрыть
                BORDER BLACK                                                    ; установка бордюра
                ; очистка атрибутов основного экрана
                SET_DE_ATTR_IPB BLACK, BLUE, 1
                LD HL, SCR_ATTR_BASE+32
                CALL SafeFill.b32
                JP_MEMCPY #E900, SCR_ATTR_BASE+32, ATTR_SIZE-32                 ; копирование блока атрибутов

                endif ; ~_MAIN_MENU_RENDER_DRAW_FLASH_
