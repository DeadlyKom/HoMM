
                ifndef _ENTRY_POINT_SWAP_SCREEN_
                define _ENTRY_POINT_SWAP_SCREEN_
; -----------------------------------------
; смена экранов 
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Swap:           ; проверка флага ожидания переключения экрана, но он не выполнен
                CHECK_RENDER_FLAG SWAP_PENDING_BIT
.Address        EQU $+1
                JP NZ, .RET                                                     ; переход, если в ожидании переключения экрана
                                                                                ; используется, если спереключение экрана мб дольше фрейма
                ; отображение счётчика FPS
                ifdef SHOW_FPS | _DEBUG
                CALL FPS_Counter.Frame
                CHECK_RENDER_FLAG FPS_DISABLE_BIT
                CALL Z, FPS_Counter.Render
                endif

                RES_RENDER_FLAG FRAME_READY_BIT                                 ; сброс флага готовности кадра

                ; проверка запрета смены экранов
                CHECK_RENDER_FLAG SWAP_DISABLE_BIT
                RET NZ                                                          ; выход, если запрещено переключение
                
                ; определение способа переключения экрана
                RENDER_FLAGS_A
                AND SWAP_TARGET_MASK
                JP Z, Screen.Swap                                               ; переключение автоматическое
                BIT SWAP_TARGET_BITS+1, A
                JP Z, Screen.ShowBase                                           ; отображение базового экрана
                JP Screen.ShowShadow                                            ; отображение теневого экрана

.RET            RET
 
                endif ; ~_ENTRY_POINT_SWAP_SCREEN_
