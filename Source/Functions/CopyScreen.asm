
                ifndef _FUNCTIONS_COPY_SCREEN_
                define _FUNCTIONS_COPY_SCREEN_
; -----------------------------------------
; функция копирования в базовый экран
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
BaseScrcpy:     ; копирование в основной экран
                SetPort PAGE_7, 1                                               ; включить 7 страницу и показать теневой экран
                LD HL, SCR_ADR_SHADOW
                LD DE, SCR_ADR_BASE
                LD BC, SCR_SIZE
                JP Memcpy.FastLDIR
; -----------------------------------------
; функция копирования в теневой экран
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
ShadowScrcpy:   ; копирование в теневой экран
                SetPort PAGE_7, 0                                               ; включить 7 страницу и показать основной экран
                LD HL, SCR_ADR_BASE
                LD DE, SCR_ADR_SHADOW
                LD BC, SCR_SIZE
                JP Memcpy.FastLDIR
; -----------------------------------------
; функция копирования в теневой экран (находясь в странице)
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
ShadowScrcpyInPage: ; копирование экрана в теневой
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                LD HL, SetPageInStack
                PUSH HL
                ; -----------------------------------------
                ; копирование данных между страницами
                ; In:
                ;   A HL - адрес исходника  (аккумулятор страница)
                ;   A'DE - адрес назначения (аккумулятор страница)
                ;   BC   - длина блока
                ; Out:
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                LD HL, SCR_ADR_BASE
                LD DE, SCR_ADR_SHADOW
                LD BC, SCR_SIZE
                EX AF, AF'
                LD A, PAGE_7
                EX AF, AF'
                JP Memcpy.BetweenPages

                display " - Function screen copy:\t\t\t\t", /A, BaseScrcpy, " = busy [ ", /D, $-BaseScrcpy, " byte(s)  ]"

                endif ; ~_FUNCTIONS_COPY_SCREEN_
