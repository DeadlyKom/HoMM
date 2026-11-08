
                ifndef _MODULE_OPTIONS_LAUNCH_OPTIONS_INITIALIZE_
                define _MODULE_OPTIONS_LAUNCH_OPTIONS_INITIALIZE_
; -----------------------------------------
; инициализация "опций"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "опций"
; -----------------------------------------
Initialize:     ; инициализация "опций"
                SET_UI_MODE UI_MODE_OPTIONS                                     ; установка UI режима "опции"
                SET_UI_LAYER #0000, #00                                         ; ToDo: активные UI слои опций пока отсутствуют

                SET_MAIN_LOOP Options.SharedCode.Loop                           ; установка главного цикла
                SET_MAIN_SWAP Options.SharedCode.Render.Swap                    ; установка обработчика переключения экранов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_OPTIONS_RENDER Options.SharedCode.Render.Draw               ; инициализация главного рендера "опций"

                ; инициализация флагов рендера "опций"
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой

                ; показ подготовленного теневого экрана перед первым кадром
                SHOW_SHADOW_SCREEN                                              ; отобразить теневой экран
                SET_USER_HANDLER Options.SharedCode.Interrupt                   ; установка обработчика прерываний

                ; сброс перемещения карты перед работой с меню опций
                LD A, (GameState.Input.Value)
                AND ~MOVEMENT_MASK
                LD (GameState.Input.Value), A
                
                RES_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; сброс запроса обновления скролла карты
                SET_TICK_REQUEST_FLAG GAME_PAUSE_REQUEST_BIT                    ; запрос паузы игры на время работы опций
                SET_TICK_CONTROL_FLAG GAME_PAUSE_BIT                            ; включение паузы игры
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                SET_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; продолжение проигрывания общей музыки игрового процесса
                RET

                endif ; ~_MODULE_OPTIONS_LAUNCH_OPTIONS_INITIALIZE_
