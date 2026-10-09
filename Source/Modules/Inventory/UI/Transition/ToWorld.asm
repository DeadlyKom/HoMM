
                ifndef _MODULE_INVENTORY_UI_TRANSITION_TO_WORLD_
                define _MODULE_INVENTORY_UI_TRANSITION_TO_WORLD_
; -----------------------------------------
; переход к UI режиму "мир"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
World:          ; завершение перехода UI инвентаря
                SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла инвентаря
                JP UI.Runtime.Complete                                          ; завершение перехода UI

                endif ; ~_MODULE_INVENTORY_UI_TRANSITION_TO_WORLD_
