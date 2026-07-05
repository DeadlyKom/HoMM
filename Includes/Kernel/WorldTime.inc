
                ifndef _KERNEL_WORLD_TIME_
                define _KERNEL_WORLD_TIME_
WorldTime:
.Tick           EQU Kernel.WorldTime.Tick                                       ; продвижение игрового календаря на один "мировой тик"
.RequestAdvance EQU Kernel.WorldTime.RequestAdvance                             ; запрос на прокрутку игрового времени
.StopAdvance    EQU Kernel.WorldTime.StopAdvance                                ; остановка дальнейшей прокрутки игрового времени
.CloseEpoch     EQU Kernel.WorldTime.CloseEpoch                                 ; завершение активной фазы "мирового тика"
.AdvanceEpoch   EQU Kernel.WorldTime.AdvanceEpoch                               ; начало новой cadence-эпохи
.IsWorldTick    EQU Kernel.WorldTime.IsWorldTick                                ; определение наличия "мирового тика" в текущем cadence-проходе
                endif ; ~_KERNEL_WORLD_TIME_
