
                ifndef _MACRO_MEMORY_
                define _MACRO_MEMORY_
; -----------------------------------------
; включение страниц
; -----------------------------------------
SET_PAGE_A      macro
                CALL SetPage
                endm
JP_SET_PAGE_A   macro
                JP SetPage
                endm
JP_PAGE_A       macro
                JP SetPage
                endm
SET_PAGE_0      macro
                XOR A
                SET_PAGE_A
                endm
JP_PAGE_0       macro
                XOR A
                JP_PAGE_A
                endm
SET_PAGE_1      macro
                LD A, #01
                SET_PAGE_A
                endm
SET_PAGE_2      macro
                LD A, #02
                SET_PAGE_A
                endm
SET_PAGE_3      macro
                LD A, #03
                SET_PAGE_A
                endm
SET_PAGE_4      macro
                LD A, #04
                SET_PAGE_A
                endm
SET_PAGE_5      macro
                LD A, #05
                SET_PAGE_A
                endm
JP_PAGE_5       macro
                LD A, #05
                JP_PAGE_A
                endm
SET_PAGE_6      macro
                LD A, #06
                SET_PAGE_A
                endm
SET_PAGE_7      macro
                LD A, #07
                SET_PAGE_A
                endm
JP_PAGE_7       macro
                LD A, #07
                JP_PAGE_A
                endm
; -----------------------------------------
; включение страницы первого экрана
; -----------------------------------------
SET_PAGE_SCREEN_BASE macro
                SET_PAGE_5
                endm
JP_SCREEN_BASE  macro
                JP_PAGE_5
                endm
; -----------------------------------------
; отображение базового экрана
; -----------------------------------------
SHOW_BASE_SCREEN macro
                CALL Screen.ShowBase
                endm
JP_SHOW_BASE_SCREEN macro
                JP Screen.ShowBase
                endm
; -----------------------------------------
; установка страницы видимого экрана
; -----------------------------------------
SET_PAGE_VISIBLE_SCREEN macro
                CALL Screen.SetPageBase
                endm
; -----------------------------------------
; включение страницы теневого экрана
; -----------------------------------------
SET_PAGE_SCREEN_SHADOW macro
                SET_PAGE_7
                endm
JP_SET_PAGE_SCREEN_SHADOW macro
                JP_PAGE_7
                endm
; -----------------------------------------
; установка страницы скрытого экран
; -----------------------------------------
SET_PAGE_HIDDEN_SCREEN macro
                CALL Screen.SetPageShadow
                endm
; -----------------------------------------
; включить экран находящийся в 3 банке (5 или 7 страница)
; -----------------------------------------
SHOW_SCREEN_FROM_PAGE_C000 macro
                CALL Screen.FromPageC000
                endm
; -----------------------------------------
; переключение экрана
; -----------------------------------------
SWAP_SCREEN     macro
                CALL Screen.Swap
                endm
; -----------------------------------------
; отображение теневого экрана
; -----------------------------------------
SHOW_SHADOW_SCREEN macro
                CALL Screen.ShowShadow
                endm

; -----------------------------------------
; копирование блока
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
MEMCPY          macro Source?, Destination?, Size?
                LD HL, Source?
                LD DE, Destination?
                LD BC, Size?
                CALL Memcpy.FastLDIR
                endm
JP_MEMCPY       macro Source?, Destination?, Size?
                LD HL, Source?
                LD DE, Destination?
                LD BC, Size?
                JP Memcpy.FastLDIR
                endm
; -----------------------------------------
; копирование данных между страницами
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
MEMCPY_PAGE     macro Source?, Destination?, DestinationPage?, Size?
                LD HL, .Continue
                PUSH HL
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                LD HL, SetPageStack
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
                LD HL, Source?
                LD DE, Destination?
                LD BC, Size?
                EX AF, AF'
                LD A, DestinationPage?
                EX AF, AF'
                JP Memcpy.BetweenPages
.Continue       EQU $
                endm
; -----------------------------------------
; установка страницы (0-31) и номер видимого экрана (0,1)
; -----------------------------------------
SetPort:        macro Page?, Screen?
                LD HL, Adr.Port_7FFD
                if Screen? = 0
                RES Screen?, (HL)
                else
                SET Screen?, (HL)
                endif
                LD A, Page?
                SET_PAGE_A
                endm
; -----------------------------------------
; сохранение номера страницы в стеке
; In:
; Out:
;   A - номер страницы памяти (0-31)
; Corrupt:
;   AF
; Note:
; -----------------------------------------
PUSH_PAGE       macro
                ; -----------------------------------------
                ; получение текущего номера страницы
                ; In:
                ; Out:
                ;   A - номер страницы памяти (0-31)
                ; Corrupt:
                ;   AF
                ; Note:
                ; -----------------------------------------
                CALL GetPage                                                    ; получение текущей страницы исходника
                PUSH AF                                                         ; сохранение страницы в стеке
                endm
; -----------------------------------------
; восстановление номера страницы из стека
; Corrupt:
;   BC, AF, AF'
; -----------------------------------------
POP_PAGE        macro
                POP AF
                SET_PAGE_A
                endm
JP_POP_PAGE     macro
                JP Func.PopPage
                endm

                endif ; ~_MACRO_MEMORY_
