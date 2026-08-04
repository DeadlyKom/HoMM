
                ifndef _MODULE_PROGRESS_WAIT_ANIMATION_CYCLE_
                define _MODULE_PROGRESS_WAIT_ANIMATION_CYCLE_
; -----------------------------------------
; ожидание завершения цикла анимации прогресса
; In:
; Out:
; Corrupt:
;   AF
; Note:
;   адрес исполнения неизвестен
;
;   переход FrameCounter из 1 в FrameNum означает
;   что функция Frame_0.bin была выполнена существующим Tick
; -----------------------------------------
WaitAnimationCycle:
                POP AF                                                          ; удаление неиспользуемого параметра

                ifdef ENABLE_LOADING_PROCESS
.WaitFrame      LD A, (Tick.FrameCounter)
                DEC A
                JR Z, .WaitReset                                                ; переход, если следующим будет выполнен Frame_0.bin

                HALT                                                            ; ожидание следующего прерывания
                JR .WaitFrame

.WaitReset      HALT                                                            ; ожидание выполнения Frame_0.bin
                LD A, (Tick.FrameCounter)
                DEC A
                JR Z, .WaitReset                                                ; переход, если Frame_0.bin ещё не выполнен

                RES_USER_HANDLER                                                ; отключение обработчика прогресса
                endif
                RET

                endif ; ~_MODULE_PROGRESS_WAIT_ANIMATION_CYCLE_
