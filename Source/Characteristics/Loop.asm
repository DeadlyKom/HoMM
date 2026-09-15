
                ifndef _CHARACTERISTICS_MAIN_LOOP_
                define _CHARACTERISTICS_MAIN_LOOP_
; -----------------------------------------
; главный цикл "характеристик"
; In:
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
Loop:           ; главный цикл "характеристик"
.Render         ; ************ RENDER ************
                ; проверка готовности кадра к показу
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, если готовый кадр ещё ожидает показа

                ; проверка запроса завершения текущего цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, Render.Draw                                               ; переход, если завершение цикла не запрошено

.Exit           ; сохранение запроса завершения до подключения перехода
                ; завершение работы текущего цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; подготовка флагов для перехода между циклами
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                RET

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_CHARACTERISTICS_MAIN_LOOP_
