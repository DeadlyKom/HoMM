
                ifndef _MACRO_FUNCTIONS_
                define _MACRO_FUNCTIONS_
; -----------------------------------------
; вызов функции с включением страницы (находясь в странице)
;   Page?     - страница
;   Function? - функция
; Corrupt:
;   HL, BC, AF, AF'
; -----------------------------------------
CALL_IN_PAGE_A  macro Function?
                LD HL, Function?
                CALL Func.CallInPage                                            ; вызов функции с включением страницы (находясь в странице)
                endm
CALL_IN_PAGE    macro Page?, Function?
                LD A, Page?
                CALL_IN_PAGE_A Function?
                endm
JP_IN_PAGE      macro Page?, Function?
                LD A, Page?
                LD HL, Function?
                JP Func.CallInPage
                endm
; -----------------------------------------
; кастомная задержка
;   Sec? - в секундах
; -----------------------------------------
DELAY           macro Sec?
                LD B, Sec? * 50
                CALL Func.CustomDelay
                endm

                endif ; ~_MACRO_FUNCTIONS_
