
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
                CHECK_RENDER_FLAG SWAPPED_PENDING_BIT
                CALL NZ, World.Base.Render.PipelineHexagons.MemcpyScreen        ; завершение обработки готового кадра, если смена экранов уже произведена
                                                                                ; после возврата начинается подготовка следующего кадра

                ; если готовый кадр ещё ожидает смены экранов,
                ; новая отрисовка не начинается, а оставшееся время передаётся планировщику
                CHECK_RENDER_FLAG FRAME_READY_BIT
                JR NZ, .ExecuteTickScheduler                                    ; переход, если кадр готов, но смена экранов не произведена
                                                                                ; исключает начало следующей отрисовки до сброса флага готовности кадра
                ; проверка завершение цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
                JR NZ, .Exit

.FuncDraw       EQU $+1
                CALL Z, $                                                       ; подготовка нового кадра

.ExecuteTickScheduler
                ; кадровый барьер проверяется до переключения страницы,
                ; чтобы повторные вызовы в одном кадре не переключали память
                LD A, (TickCounterRef)
.LastTickCounter EQU $+1
                CP #00
                RET Z                                                           ; выход, если в текущем кадре запуск уже выполнялся
                LD (.LastTickCounter), A

                ; оставшееся время кадра передаётся планировщику обновления объектов
                CHECK_INTERRUPT_FLAG INT_DISABLE_GLOBAL_TICK_BIT
                RET NZ                                                          ; выход, если глобальный тик отключён

                PUSH_PAGE
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL Page0.Object.TickScheduler.Executor
                JP_POP_PAGE

.Exit           ; сброс флага завершение цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; установка флагов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                JR$

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_WORLD_MAIN_LOOP_
