
                ifndef _FUNCTIONS_CLEAR_SCREEN_
                define _FUNCTIONS_CLEAR_SCREEN_
; -----------------------------------------
; функция очистки базовый экран
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
BaseClear:      ; очистка основного экрана
                SHOW_SHADOW_SCREEN                                              ; отобразить теневой экран
                JumpCLS SCR_ADR_BASE, 0x00
; -----------------------------------------
; функция заполнения атрибутов базового экрана
; In:
;   DE - заполняемое значение
; Out:
; Corrupt:
; Note:
; -----------------------------------------
BaseFillATTR:   SCREEN_ATTR_ADR_REG HL, SCR_ADR_BASE + SCR_ATTR_SIZE, 0, 0
                JP SafeFill.b768
; -----------------------------------------
; функция очистки теневого экрана
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ShadowClear:    ; очистка теневого экрана
                SHOW_BASE_SCREEN                                                ; отобразить основной экран
                JumpCLS SCR_ADR_SHADOW, 0x00
; -----------------------------------------
; функция очистки теневого экрана (находясь в странице)
; In:
;   DE - заполняемое значение атрибутов
;   A  - значение для заполнения пикселей экрана
; Out:
; Corrupt:
;   HL, DE, AF, IX
; Note:
; -----------------------------------------
.InPage         EX AF, AF'                                                      ; сохранение заполняемого пиксельного значения
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                PUSH DE
                ; заполнение пикселей теневого экрана
                SCREEN_ADR_REG HL, SCR_ADR_SHADOW + SCR_PIXEL_SIZE, 0, 0
                EX AF, AF'                                                      ; восстановление заполняемого пиксельного значения
                LD D, A
                LD E, A
                CALL SafeFill.Screen

                ; заполнение атрибутов теневого экрана
                POP DE
                CALL ShadowFillATTR
                JP_POP_PAGE                                                     ; восстановление номера страницы из стека
; -----------------------------------------
; функция заполнения атрибутов теневого экрана
; In:
;   DE - заполняемое значение
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ShadowFillATTR: SCREEN_ATTR_ADR_REG HL, SCR_ADR_SHADOW + SCR_ATTR_SIZE, 0, 0
                JP SafeFill.b768

                display " - Function screen fill:\t\t\t\t", /A, BaseClear, "\t= busy [ ", /D, $-BaseClear, " byte(s)  ]"

                endif ; ~_FUNCTIONS_CLEAR_SCREEN_
