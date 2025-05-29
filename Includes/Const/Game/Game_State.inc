
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
FINISHED_BIT        EQU 0x00                                                    ; флаг, рендер завершён
SWAP_DISABLE_BIT    EQU 0x01                                                    ; флаг, отключение смены экранов
FPS_DISABLE_BIT     EQU 0x02                                                    ; флаг, отключения отображения FPS

; флаги работы с прерыванием
INT_DISABLE_GLOBAL_TICK_BIT EQU 0x00                                            ; флаг, отключения глобального тика

                endif ; ~_CONST_GAME_STATE_
