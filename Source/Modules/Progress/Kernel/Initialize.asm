
                ifndef _MODULE_PROGRESS_INITIALIZE_
                define _MODULE_PROGRESS_INITIALIZE_
; -----------------------------------------
; первичная инициализация
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     BORDER BLACK                                                    ; установка бордюра

                ; -----------------------------------------
                ; первичная очистка экранов
                ; -----------------------------------------
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана
                CLS_SCR_SHADOW_IN_PAGE 0xFF, BLACK, WHITE, 0                    ; очистка теневого экрана (находясь в странице)

                POP AF                                                          ; чтение идентификатора картинки
                RET

                endif ; ~_MODULE_PROGRESS_INITIALIZE_
