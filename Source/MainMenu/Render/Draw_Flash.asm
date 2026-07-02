
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
                ATTR_IPB SCR_ADR_BASE, WHITE, WHITE, 0                          ; очистка атрибутов основного экрана
                SET_REG_PAIR_ATTR_IPB HL, WHITE, BLUE, 0
                SET_TO_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X, SCR_CHUR_POX_Y + 0
                SET_TO_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X, SCR_CHUR_POX_Y + 1
                SET_TO_ATTR_ADR_REG HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X, SCR_CHUR_POX_Y + 2
                RET

.Hide           ; скрыть
                BORDER BLACK                                                    ; установка бордюра
                JP_ATTR_IPB SCR_ADR_BASE, BLACK, BLUE, 1                        ; очистка атрибутов основного экрана

                endif ; ~_MAIN_MENU_RENDER_DRAW_FLASH_
