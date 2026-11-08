
                ifndef _MODULE_BATTLE_LAUNCH_BATTLE_INITIALIZE_
                define _MODULE_BATTLE_LAUNCH_BATTLE_INITIALIZE_
; -----------------------------------------
; инициализация "битвы"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "битвы"
; -----------------------------------------
Initialize:     ; инициализация "битвы"
                SET_UI_MODE UI_MODE_BATTLE                                      ; установка UI режима "битва"
                SET_UI_LAYER #0000, #00                                         ; ToDo: активные UI слои битвы пока отсутствуют

                SET_MAIN_LOOP Battle.SharedCode.Loop                            ; установка главного цикла
                SET_MAIN_SWAP Battle.SharedCode.Render.Swap                     ; установка обработчика переключения экранов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_BATTLE_RENDER Battle.SharedCode.Render.Draw                 ; инициализация главного рендера "битвы"

                ; инициализация флагов рендера "битвы"
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой

                ; показ подготовленного теневого экрана перед первым кадром
                SHOW_SHADOW_SCREEN                                              ; отобразить теневой экран
                SET_USER_HANDLER Battle.SharedCode.Interrupt                    ; установка обработчика прерываний

                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                SET_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; продолжение проигрывания общей музыки игрового процесса
                RET

                endif ; ~_MODULE_BATTLE_LAUNCH_BATTLE_INITIALIZE_
