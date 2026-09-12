
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
CALL_HL         macro
                CALL Func.JP_HL
                endm
CALL_IX         macro
                CALL Func.JP_IX
                endm
CALL_IY         macro
                CALL Func.JP_IY
                endm
; -----------------------------------------
; преобразование дробного значения в fixed point и сохранение через DB
;   Value?        - дробное значение
;   FractionBits? - количество дробных битов
; Note:
;   результат округляется до ближайшего целого значения
; -----------------------------------------
TO_FP_BYTE      macro Value?, FractionBits?
                define __FLOAT_BYTE_VALUE__ Value?
                define __FLOAT_BYTE_FRACTION_BITS__ FractionBits?
                lua allpass
                    local value = tonumber(sj.get_define("__FLOAT_BYTE_VALUE__"))
                    local fraction_bits = tonumber(sj.get_define("__FLOAT_BYTE_FRACTION_BITS__"))
                    if value == nil then
                        error("невозможно преобразовать значение в байтовый fixed point")
                    end
                    if fraction_bits == nil or fraction_bits < 0 or
                            fraction_bits ~= math.floor(fraction_bits) then
                        error("количество дробных битов должно быть неотрицательным целым числом")
                    end

                    local scaled = value * (2.0 ^ fraction_bits)
                    local fixed
                    if scaled < 0.0 then
                        fixed = math.ceil(scaled - 0.5)
                    else
                        fixed = math.floor(scaled + 0.5)
                    end

                    if fixed < -128 or fixed > 255 then
                        error("значение fixed point не помещается в байт")
                    end

                    _pc("DB " .. fixed)
                endlua
                undefine __FLOAT_BYTE_VALUE__
                undefine __FLOAT_BYTE_FRACTION_BITS__
                endm
; -----------------------------------------
; преобразование дробного значения в fixed point и сохранение через DW
;   Value?        - дробное значение
;   FractionBits? - количество дробных битов
; Note:
;   результат округляется до ближайшего целого значения
; -----------------------------------------
TO_FP_WORD      macro Value?, FractionBits?
                define __FLOAT_WORD_VALUE__ Value?
                define __FLOAT_WORD_FRACTION_BITS__ FractionBits?
                lua allpass
                    local value = tonumber(sj.get_define("__FLOAT_WORD_VALUE__"))
                    local fraction_bits = tonumber(sj.get_define("__FLOAT_WORD_FRACTION_BITS__"))
                    if value == nil then
                        error("невозможно преобразовать значение в fixed point для слова")
                    end
                    if fraction_bits == nil or fraction_bits < 0 or
                            fraction_bits ~= math.floor(fraction_bits) then
                        error("количество дробных битов должно быть неотрицательным целым числом")
                    end

                    local scaled = value * (2.0 ^ fraction_bits)
                    local fixed
                    if scaled < 0.0 then
                        fixed = math.ceil(scaled - 0.5)
                    else
                        fixed = math.floor(scaled + 0.5)
                    end

                    if fixed < -32768 or fixed > 65535 then
                        error("значение fixed point не помещается в слово")
                    end

                    _pc("DW " .. fixed)
                endlua
                undefine __FLOAT_WORD_VALUE__
                undefine __FLOAT_WORD_FRACTION_BITS__
                endm
; -----------------------------------------
; преобразование дробного значения в константу fixed point
;   Name?         - имя константы
;   Value?        - дробное значение
;   FractionBits? - количество дробных битов
; Note:
;   результат округляется до ближайшего целого значения
; -----------------------------------------
TO_FP_EQU       macro Name?, Value?, FractionBits?
                define __FLOAT_EQU_VALUE__ Value?
                define __FLOAT_EQU_FRACTION_BITS__ FractionBits?
                lua allpass
                    local value = tonumber(sj.get_define("__FLOAT_EQU_VALUE__"))
                    local fraction_bits = tonumber(sj.get_define("__FLOAT_EQU_FRACTION_BITS__"))
                    if value == nil then
                        error("невозможно преобразовать значение в константу fixed point")
                    end
                    if fraction_bits == nil or fraction_bits < 0 or
                            fraction_bits ~= math.floor(fraction_bits) then
                        error("количество дробных битов должно быть неотрицательным целым числом")
                    end

                    local scaled = value * (2.0 ^ fraction_bits)
                    local fixed
                    if scaled < 0.0 then
                        fixed = math.ceil(scaled - 0.5)
                    else
                        fixed = math.floor(scaled + 0.5)
                    end

                    sj.insert_define_i("__FLOAT_EQU_RESULT__", fixed)
                endlua
Name?           EQU __FLOAT_EQU_RESULT__
                undefine __FLOAT_EQU_VALUE__
                undefine __FLOAT_EQU_FRACTION_BITS__
                undefine __FLOAT_EQU_RESULT__
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
