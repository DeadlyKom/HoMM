
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
                SET_UI_LAYER Inventory.UI.Layers.Inventory, \
                            Inventory.UI.Layers.Inventory.Num                   ; установка активного UI слои инвентаря

                SET_MAIN_LOOP Inventory.SharedCode.Loop                         ; установка главного цикла
                SET_MAIN_SWAP Inventory.SharedCode.Render.CopyScreen.Swap       ; установка обработчика показа основного экрана
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_INVENTORY_RENDER Inventory.SharedCode.Render.Draw           ; инициализация главного рендера "инвентаря"

                ; инициализация флагов рендера инвентаря
                RES_RENDER_FLAGS FRAME_READY | SWAPPED_PENDING | SWAP_PENDING | FPS_DISABLE

                ; показ подготовленного теневого экрана перед первым кадром
                SHOW_SHADOW_SCREEN
                SET_USER_HANDLER Inventory.SharedCode.Interrupt                 ; установка обработчика прерываний
                
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; запретить проигрывать музыку
                SET_RENDER_SHADOW                                               ; установка Render флага переключения на теневой экран
                RET

                endif ; ~_MODULE_INVENTORY_LAUNCH_INVENTORY_INITIALIZE_
