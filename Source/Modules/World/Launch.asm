
                ifndef _WORLD_LAUNCH_
                define _WORLD_LAUNCH_
; -----------------------------------------
; запуск "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Launch:         SET_MAIN_LOOP World.Loop                                        ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_WORLD_RENDER World.Render.Draw                              ; инициализаци главного рендера "мира"
                SET_USER_HANDLER World.Interrupt                                ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_RENDER_FLAG SWAP_DISABLE_BIT                                ; разрешить смену экранов
                SET_MOUSE_POSITION 128, 96                                      ; установить позицию мыши
                RET

                display " - Launch:\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_WORLD_LAUNCH_
