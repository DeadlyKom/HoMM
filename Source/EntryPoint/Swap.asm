
                ifndef _ENTRY_POINT_SWAP_SCREEN_
                define _ENTRY_POINT_SWAP_SCREEN_
; -----------------------------------------
; смена экранов 
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Swap:           ; отображение счётчика FPS
                ifdef SHOW_FPS | _DEBUG
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL FPS_Counter.Frame
                CALL FPS_Counter.Render
                endif

                ; проверка запрета смены экранов
                CHECK_RENDER_FLAG SWAP_DISABLE_BIT
                CALL Z, Screen.Swap

                RES_RENDER_FLAG FINISHED_BIT                                    ; обнуление флага FINISHED_BITёёёё
                RET
 
                endif ; ~_ENTRY_POINT_SWAP_SCREEN_
