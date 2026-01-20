
                ifndef _WORLD_MAIN_LOOP_
                define _WORLD_MAIN_LOOP_
; -----------------------------------------
; главный цикл "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Loop:           
.Render         ; ************ RENDER ************
                RENDER_FLAGS
                CHECK_FLAG SWAPPED_PENDING_BIT
                JP NZ, World.Base.Render.PipelineHexagons.MemcpyScreen          ; переход, если кадр готов и была произведена смена экранов
                CHECK_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, кадр готов, но смена экрана не произведена
                                                                                ; исключает процесс начала следующей отрисовки, до сброса флага
                ; проверка завершение цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $

                ; сброс флага завершение цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; установка флагов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                
                JR$

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_WORLD_MAIN_LOOP_
