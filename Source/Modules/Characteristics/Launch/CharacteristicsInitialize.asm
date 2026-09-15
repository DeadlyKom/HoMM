
                ifndef _MODULE_CHARACTERISTICS_LAUNCH_CHARACTERISTICS_INITIALIZE_
                define _MODULE_CHARACTERISTICS_LAUNCH_CHARACTERISTICS_INITIALIZE_
; -----------------------------------------
; инициализация "характеристик"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "характеристик"
; -----------------------------------------
Initialize:     ; инициализация "характеристик"
                SET_UI_MODE UI_MODE_CHARACTERISTICS                             ; установка UI режима "характеристики"
                SET_MAIN_LOOP Characteristics.SharedCode.Loop                   ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов запуска

                RET

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_CHARACTERISTICS_INITIALIZE_
