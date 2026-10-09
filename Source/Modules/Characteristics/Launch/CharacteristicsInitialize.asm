
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
                SET_UI_LAYER #0000, #00                                         ; ToDo: активные UI слои характеристик пока отсутствуют
                SET_MAIN_LOOP Characteristics.SharedCode.Loop                   ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов

                SET_CHARACTERISTICS_RENDER Characteristics.SharedCode.Render.Draw   ; инициализация главного рендера "характеристик"

                SET_USER_HANDLER Characteristics.SharedCode.Interrupt           ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; запретить проигрывать музыку
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                RET

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_CHARACTERISTICS_INITIALIZE_
