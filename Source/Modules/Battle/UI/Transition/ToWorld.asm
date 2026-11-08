
                ifndef _MODULE_BATTLE_UI_TRANSITION_TO_WORLD_
                define _MODULE_BATTLE_UI_TRANSITION_TO_WORLD_
; -----------------------------------------
; переход к UI режиму "мир"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "битвы"
; -----------------------------------------
World:          ; завершение перехода UI битвы
                SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла битвы
                JP UI.Runtime.Complete                                          ; завершение перехода UI

                endif ; ~_MODULE_BATTLE_UI_TRANSITION_TO_WORLD_
