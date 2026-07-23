
                ifndef _MODULE_PROGRESS_KERNEL_BIND_
                define _MODULE_PROGRESS_KERNEL_BIND_
KERNEL_ID_COUNTER   defl 0                                                      ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с ID 0 автоматически вызывается после релокации ассета
                BIND_ID_KERNEL Progress.AutoStart,      Launch                  ; функция запуска ассета        (0)

                ; функции, запрошенные вызывающим кодом
                BIND_ID_KERNEL Progress.Initialize,     Kernel.Initialize       ; первичная инициализация
                BIND_ID_KERNEL Progress.EnterProgress,  Kernel.EnterProgress    ; продвижение прогресса
                BIND_ID_KERNEL Progress.ToPercent,      Kernel.ProgressToPer    ; продвижение до указанного процента
                BIND_ID_KERNEL Progress.Release,        Kernel.Release          ; освобождение ассета

                endif ; ~_MODULE_PROGRESS_KERNEL_BIND_
