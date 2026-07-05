
                ifndef _KERNEL_WORLD_TIME_
                define _KERNEL_WORLD_TIME_
WorldTime:
.Tick           EQU Kernel.WorldTime.Tick                                       ; продвижение игрового календаря на один "мировой тик"
.RequestAdvance EQU Kernel.WorldTime.RequestAdvance                             ; запрос на прокрутку игрового времени
.StopAdvance    EQU Kernel.WorldTime.StopAdvance                                ; остановка дальнейшей прокрутки игрового времени
.CloseEpoch     EQU Kernel.WorldTime.CloseEpoch                                 ; завершение активной фазы "мирового тика"
.AdvanceEpoch   EQU Kernel.WorldTime.AdvanceEpoch                               ; начало новой cadence-эпохи
.IsWorldTick    EQU Kernel.WorldTime.IsWorldTick                                ; определение наличия "мирового тика" в текущем cadence-проходе

                ifdef _DEBUG
.DebugRender    EQU Kernel.WorldTime.DebugRender                                ; отладочное отображение игрового календаря
.DebugRender.Flag EQU Kernel.WorldTime.DebugRender.Flag                         ; флаг, необходимости обновления отладочного отображения
                endif

                endif ; ~_KERNEL_WORLD_TIME_
