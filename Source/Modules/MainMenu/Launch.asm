
                ifndef _MODULE_MAIN_MENU_LAUNCH_
                define _MODULE_MAIN_MENU_LAUNCH_
; -----------------------------------------
; запуск "главного меню"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Launch:         ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.MainMenu.Page), A

                MEMCPY Adr.Deploy.MainMenu, Adr.MainMenu, Size.Deploy.MainMenu  ; копирование блока

                ; инициализация мира 
                SET_MAIN_LOOP MainMenu.Base.Loop                                ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_MAIN_MENU_RENDER MainMenu.Base.Render.Draw                  ; инициализаци главного рендера "мира"
                SET_USER_HANDLER MainMenu.Base.Interrupt                        ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_RENDER_FLAG SWAP_DISABLE_BIT                                ; разрешить смену экранов
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                SET_MOUSE_POSITION 128, 96                                      ; установить позицию мыши
                RET

                display " - Launch:\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_MAIN_MENU_LAUNCH_
