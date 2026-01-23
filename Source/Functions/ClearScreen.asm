
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
BaseFillATTR:   SCREEN_ATTR_ADR_REG HL, SCR_ADR_BASE + 0x0300, 0, 0
                JP SafeFill.b768
; -----------------------------------------
; функция очистки теневой экран
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ShadowClear:    ; очистка теневого экрана
                SHOW_BASE_SCREEN                                                ; отобразить основной экран
                JumpCLS SCR_ADR_SHADOW, 0x00
; -----------------------------------------
; функция заполнения атрибутов теневого экрана
; In:
;   DE - заполняемое значение
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ShadowFillATTR: SCREEN_ATTR_ADR_REG HL, SCR_ADR_SHADOW + 0x0300, 0, 0
                JP SafeFill.b768

                display " - Function screen fill:\t\t\t\t", /A, BaseClear, " = busy [ ", /D, $-BaseClear, " byte(s)  ]"

                endif ; ~_FUNCTIONS_CLEAR_SCREEN_
