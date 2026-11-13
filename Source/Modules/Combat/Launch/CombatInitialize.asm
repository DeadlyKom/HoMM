
                ifndef _MODULE_COMBAT_LAUNCH_COMBAT_INITIALIZE_
                define _MODULE_COMBAT_LAUNCH_COMBAT_INITIALIZE_
; -----------------------------------------
; инициализация "сражения"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "сражения"
; -----------------------------------------
Initialize:     ; инициализация "сражения"
                SET_UI_MODE UI_MODE_COMBAT                                      ; установка UI режима "сражение"
                SET_UI_LAYER #0000, #00                                         ; ToDo: активные UI слои "сражения" пока отсутствуют

                SET_MAIN_LOOP Combat.SharedCode.Loop                            ; установка главного цикла
                SET_MAIN_SWAP Combat.SharedCode.Render.Swap                     ; установка обработчика переключения экранов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_COMBAT_RENDER Combat.SharedCode.Render.Draw                 ; инициализация главного рендера "сражения"

                ; инициализация флагов рендера "сражения"
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой

                ; показ подготовленного теневого экрана перед первым кадром
                SHOW_SHADOW_SCREEN                                              ; отобразить теневой экран
                SET_USER_HANDLER Combat.SharedCode.Interrupt                    ; установка обработчика прерываний

                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                SET_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; продолжение проигрывания общей музыки игрового процесса
                RET

                endif ; ~_MODULE_COMBAT_LAUNCH_COMBAT_INITIALIZE_
