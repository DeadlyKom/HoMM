
                ifndef _MODULE_OPTIONS_UI_TRANSITION_TO_WORLD_
                define _MODULE_OPTIONS_UI_TRANSITION_TO_WORLD_
; -----------------------------------------
; переход к UI режиму "мир"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "опций"
; -----------------------------------------
World:          ; завершение перехода UI "опций"
                SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла "опций"
                JP UI.Runtime.Complete                                          ; завершение перехода UI

                endif ; ~_MODULE_OPTIONS_UI_TRANSITION_TO_WORLD_
