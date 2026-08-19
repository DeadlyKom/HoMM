
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
CALL_IX         macro
                CALL Func.JP_IX
                endm
CALL_IY         macro
                CALL Func.JP_IY
                endm
; -----------------------------------------
; задержка на заданное количество секунд
;   Sec? - длительность в секундах, включая дробные значения
; Note:
;   длительность округляется до ближайшего кадра при частоте 50 Гц;
;   допустимый диапазон результата: 1-255 кадров
; -----------------------------------------
DELAY           macro Sec?
                define __DELAY_SECONDS__ Sec?
                lua allpass
                    local seconds = tonumber(sj.get_define("__DELAY_SECONDS__"))
                    if seconds == nil or seconds <= 0.0 then
                        error("длительность задержки должна быть положительным числом")
                    end

                    local frames = math.floor(seconds * 50.0 + 0.5)
                    if frames < 1 then
                        frames = 1
                    elseif frames > 255 then
                        error("длительность задержки не должна превышать 255 кадров (5.1 секунды)")
                    end

                    _pc("LD B, " .. frames)
                endlua
                undefine __DELAY_SECONDS__
                CALL Func.CustomDelay
                endm

                endif ; ~_MACRO_FUNCTIONS_
