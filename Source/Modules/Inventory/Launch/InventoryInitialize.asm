
                ifndef _MODULE_INVENTORY_LAUNCH_INVENTORY_INITIALIZE_
                define _MODULE_INVENTORY_LAUNCH_INVENTORY_INITIALIZE_
; -----------------------------------------
; инициализация "инвентаря"
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Initialize:     ; инициализация "инвентаря"
                SET_UI_MODE UI_MODE_INVENTORY                                   ; установка UI режима "инвентарь"
                SET_UI_LAYER #0000, #00                                         ; ToDo: активные UI слои инвентаря пока отсутствуют
                SET_MAIN_LOOP Inventory.SharedCode.Loop                         ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов

                SET_INVENTORY_RENDER Inventory.SharedCode.Render.Draw           ; инициализация главного рендера "инвентаря"

                SET_USER_HANDLER Inventory.SharedCode.Interrupt                 ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; запретить проигрывать музыку
                SET_RENDER_SHADOW                                               ; установка Render флага переключения на теневой экран
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                RET

                endif ; ~_MODULE_INVENTORY_LAUNCH_INVENTORY_INITIALIZE_
