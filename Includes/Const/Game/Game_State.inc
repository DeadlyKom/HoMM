
                ifndef _CONST_GAME_STATE_
                define _CONST_GAME_STATE_

; флаги работы с главным циклом
ML_TRANSITION_BIT   EQU 0x00                                                    ; флаг, переход между циклами
ML_ENTER_BIT        EQU 0x01                                                    ; флаг, первичного запуска (необходимо для инициализации)
ML_EXIT_BIT         EQU 0x02                                                    ; флаг, завершения цикла
ML_UPDATE_BIT       EQU 0x03                                                    ; флаг, бновления

ML_TRANSITION       EQU 1 << ML_TRANSITION_BIT
ML_ENTER            EQU 1 << ML_ENTER_BIT
ML_EXIT             EQU 1 << ML_EXIT_BIT
ML_UPDATE           EQU 1 << ML_UPDATE_BIT

; флаги работы с рендером
FRAME_READY_BIT     EQU 0x00                                                    ; флаг, готовности кадра
SWAP_PENDING_BIT    EQU 0x01                                                    ; флаг, ожидания переключения экрана, но он не выполнен
SWAPPED_PENDING_BIT EQU 0x02                                                    ; флаг, переключение экрана выполнено, ожидаем окончание прерывания
SWAP_TARGET_BITS    EQU 0x03                                                    ; дополнительные биты, переключения экранов (2 и 3 бит)
                                                                                ; 00 - переключение автоматическое
                                                                                ; 01 - переключение только на базовый экран
                                                                                ; 11 - переключение только на теневой экран
SWAP_DISABLE_BIT    EQU 0x06                                                    ; флаг, отключение смены экранов
FPS_DISABLE_BIT     EQU 0x07                                                    ; флаг, отключения отображения FPS

SWAP_TARGET_MASK    EQU %00011000
SWAP_PENDING        EQU 1 << SWAP_PENDING_BIT
SWAPPED_PENDING     EQU 1 << SWAPPED_PENDING_BIT

; флаги работы с прерыванием
INT_DISABLE_GLOBAL_TICK_BIT EQU 0x00                                            ; флаг, отключения глобального тика

                endif ; ~_CONST_GAME_STATE_
