
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
                ; SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                ; CLS SCR_ADR_SHADOW, 0xFF                                        ; очистка теневого экрана
                ; ATTR_IPB SCR_ADR_SHADOW, BLACK, WHITE, 0                        ; очистка атрибутов теневого экрана
                ; SHOW_SHADOW_SCREEN                                              ; отобразить теневой экран


                POP AF                                                          ; чтение идентификатора картинки
                RET

                endif ; ~_MODULE_PROGRESS_INITIALIZE_
