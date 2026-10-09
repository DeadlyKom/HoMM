
                ifndef _MODULE_CHARACTERISTICS_UI_TRANSITION_TO_WORLD_
                define _MODULE_CHARACTERISTICS_UI_TRANSITION_TO_WORLD_
; -----------------------------------------
; переход к UI режиму "мир"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "характеристик"
; -----------------------------------------
World:          ; завершение перехода UI характеристик
                SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла характеристик
                JP UI.Runtime.Complete                                          ; завершение перехода UI

                endif ; ~_MODULE_CHARACTERISTICS_UI_TRANSITION_TO_WORLD_
