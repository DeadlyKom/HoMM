
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
                CALL FPS_Counter.Frame
                CALL FPS_Counter.Render
                endif

                ; проверка запрета смены экранов
                CHECK_RENDER_FLAG SWAP_DISABLE_BIT
                CALL Z, Screen.Swap

                RES_RENDER_FLAG FINISHED_BIT                                    ; обнуление флага FINISHED_BIT
                RET
 
                endif ; ~_ENTRY_POINT_SWAP_SCREEN_
