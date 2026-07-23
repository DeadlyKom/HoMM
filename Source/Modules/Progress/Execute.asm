
                ifndef _MODULE_PROGRESS_EXECUTE_
                define _MODULE_PROGRESS_EXECUTE_
; -----------------------------------------
; преобразование процентов в fixed-point 8.8
; In:
;   Percent? - значение в процентах (0.0-100.0)
; Out:
;   BC - положение среди 26 этапов в формате fixed-point 8.8
; Corrupt:
;   BC
; Note:
;   преобразование выполняется во время сборки через Lua
; -----------------------------------------
PROGRESS_PERCENT_FIXED macro Percent?
                define __PROGRESS_PERCENT__ Percent?
                lua allpass
                    local percent = tonumber(sj.get_define("__PROGRESS_PERCENT__"))
                    if percent == nil or percent < 0.0 or percent > 100.0 then
                        error("процент прогресса должен находиться в диапазоне 0.0-100.0")
                    end

                    local fixed = math.floor(percent * (26 << 8) / 100.0 + 0.5)
                    _pc("LD BC, " .. fixed)
                endlua
                undefine __PROGRESS_PERCENT__
                endm
; -----------------------------------------
; запуск модуля "окно прогресса"
; In:
;   A - идентификатор запускаемой функции
;   BC - параметр функции:
;        Initialize    - идентификатор картинки в B
;        EnterProgress - шаг прогресса в формате fixed-point 8.8
;        ToPercent     - конечное значение прогресса в формате fixed-point 8.8
;        Release       - значение параметра не используется
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Progress:       PUSH BC                                                         ; сохранение параметра функции
                PUSH AF                                                         ; сохранение идентификатора запускаемой функции
                JP_EXE_ASSET_FUNCTION_TWO_PARAMS ASSETS_ID_PROGRESS             ; загрузка ресурса и запуск функции ассета
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а
.CurrentPercent DW #0000                                                        ; текущее значение прогресса в формате fixed-point 8.8

                endif ; ~_MODULE_PROGRESS_EXECUTE_
