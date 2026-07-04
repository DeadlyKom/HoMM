
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
                ; после успешного показа готового кадра завершить обработку экранов
                CHECK_RENDER_FLAG SWAPPED_PENDING_BIT
                JP NZ, .MemcpyScreen                                            ; переход, если смена экранов уже произведена

                ; готовый кадр ещё ожидает показа в прерывании
                ; до смены экранов не начинать новую отрисовку и не запускать планировщик
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, если кадр готов, но смена экранов ещё не произведена
                                                                                ; не передавать управление планировщику до показа готового кадра,
                                                                                ; чтобы обновление объектов начиналось только после завершения смены экранов

                ; проверка завершения работы текущего цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $                                                         ; переход к подготовке нового кадра

.Exit           ; завершение работы текущего цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; подготовка флагов для перехода между циклами
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                JR$

.MemcpyScreen   ; завершение обработки уже показанного кадра и подготовка экранов к следующей отрисовке
                CALL World.Base.Render.PipelineHexagons.MemcpyScreen

.TickScheduler  ; после показа кадра оставшееся время передаётся планировщику обновления объектов
                ; кадровый барьер проверяется до переключения страницы,
                ; чтобы не запускать планировщик и не переключать память повторно в одном аппаратном кадре
                LD A, (TickCounterRef)
.LastTick       EQU $+1
                CP #00
                RET Z                                                           ; выход, если в текущем кадре запуск уже выполнялся
                LD (.LastTick), A

                ; проверка разрешения обновления объектов
                CHECK_INTERRUPT_FLAG INT_DISABLE_GLOBAL_TICK_BIT
                RET NZ                                                          ; выход, если глобальный тик отключён

                ; переход на страницу объектов с возвратом через SetPageInStack
                PUSH_PAGE                                                       ; сохранение номера текущей страницы в стеке
                LD HL, SetPageInStack
                PUSH HL
                SET_PAGE_OBJECT                                                 ; включение страницы работы с объектами
                JP Page0.Object.TickScheduler.Executor

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_WORLD_MAIN_LOOP_
