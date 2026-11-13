
                ifndef _MODULE_COMBAT_UI_TRANSITION_TO_WORLD_
                define _MODULE_COMBAT_UI_TRANSITION_TO_WORLD_
; -----------------------------------------
; переход к UI режиму "мир"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "сражения"
; -----------------------------------------
World:          ; завершение перехода UI "сражения"
                SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла "сражения"
                JP UI.Runtime.Complete                                          ; завершение перехода UI

                endif ; ~_MODULE_COMBAT_UI_TRANSITION_TO_WORLD_
