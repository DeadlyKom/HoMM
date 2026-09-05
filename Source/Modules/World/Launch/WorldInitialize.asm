
                ifndef _MODULE_WORLD_LAUNCH_WORLD_INITIALIZE_
                define _MODULE_WORLD_LAUNCH_WORLD_INITIALIZE_
; -----------------------------------------
; инициализация "мира"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
WorldInitialize:; инициализация "мира"
                SET_UI_MODE UI_MODE_WORLD                                       ; установить UI режим "мир"
                SET_UI_LAYER World.Base.Layers.GameWorld, \
                                World.Base.Layers.GameWorld.Num                 ; установка активного UI слоя
                SET_TICK_CONTROL_FLAGS GAME_SUSPEND                             ; "мир" запускается в режиме "остановки времени"
                SET_TICK_REQUEST_FLAGS GAME_SUSPEND_REQUEST                     ; запрос соответствует фактическому состоянию
                SET_MAIN_LOOP World.Base.Loop                                   ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_MAIN_SWAP World.Base.Render.PipelineHexagons.Swap           ; установить функцию долгого переключения экранов
                SET_WORLD_RENDER World.Base.Render.Draw                         ; инициализаци главного рендера "мира"
                SET_USER_HANDLER World.Base.Interrupt                           ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                ; SET_RENDER_FLAG SWAP_DISABLE_BIT                                ; запретить смену экранов
                RES_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; запретить проигрывать музыку
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                SET_MOUSE_POSITION 128, 96                                      ; установить позицию мыши
                RET

                endif ; ~_MODULE_WORLD_LAUNCH_WORLD_INITIALIZE_
